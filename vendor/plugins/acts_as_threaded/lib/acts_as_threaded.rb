module ActiveRecord
  module Acts #:nodoc:
    module Threaded #:nodoc:
      def self.included(base)
        base.extend(ClassMethods)  
      end
      
      module ClassMethods
        def acts_as_threaded(options = {})
          write_inheritable_attribute(:acts_as_threaded_options, {
            :thread_type => ActiveRecord::Base.send(:class_name_of_active_record_descendant, self).to_s,
            :from => options[:from],
            :conditions=>options[:conditions],
            :foreign_key => (options[:parent_id]||"parent_id")
          })
          
          class_inheritable_reader :acts_as_threaded_options
          acts_as_tree :options
          
          attr_protected :ancestors, :descendants 

          has_and_belongs_to_many :descendants, :conditions=>acts_as_threaded_options[:conditions], :class_name=>acts_as_threaded_options[:thread_type], :join_table=>"thread_branches", :foreign_key=>"thread_id", :association_foreign_key=>"branch_node_id"
          has_and_belongs_to_many :ancestors, :conditions=>acts_as_threaded_options[:conditions], :class_name=>acts_as_threaded_options[:thread_type], :join_table=>"thread_branches", :association_foreign_key=>"thread_id", :foreign_key=>"branch_node_id"

          after_create :weave_threads

          include ActiveRecord::Acts::Threaded::InstanceMethods
          extend ActiveRecord::Acts::Threaded::SingletonMethods          
        end
      end
      
      module SingletonMethods
        def find_thread(id)
          obj = find(id)
          obj.find_thread
        end
      end

      module InstanceMethods
        def find_thread()
          thread = {}

          descendants.each do |desc|
            thread[desc.parent_id] = [] unless thread.has_key? desc.parent_id
            thread[desc.parent_id] << desc
          end
          
          thread
        end

        def ancestor_threads
          @ancestor_threads ||= ThreadBranch.find_by_sql(["select * from thread_branches tb where branch_node_id=? and tb.thread_type=?", self.id, acts_as_threaded_options[:thread_type]])  
        end

        def descendant_count
          descendants.count
        end

        def exists_in_thread thread_id
          ThreadBranch.find(:first, :conditions=>["thread_id in (?) and branch_node_id=? and thread_type=?", thread_id, id, acts_as_threaded_options[:thread_type]]) != nil
        end
        
        def weave_threads
            grandparents = parent.ancestor_threads  if parent
             t = ThreadBranch.new({"thread_id"=>self.parent_id, "branch_node_id"=>self.id, "levels_from_root"=>1,"thread_type"=>acts_as_threaded_options[:thread_type], "branch_node_type"=>acts_as_threaded_options[:thread_type]})
             t.save
             if grandparents
              

               grandparents.each do |ancestor|
                 t = ThreadBranch.new({"thread_id"=>ancestor.thread_id, "branch_node_id"=>self.id, "levels_from_root"=>ancestor.levels_from_root+1, "thread_type"=>acts_as_threaded_options[:thread_type], "branch_node_type"=>acts_as_threaded_options[:thread_type]})
                 t.save
               end  
             end
        end   
      end
    end
  end
end
