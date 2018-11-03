class ThreadBranch < ActiveRecord::Base
   belongs_to :thread, :foreign_key=>"thread_id", :polymorphic=>true
   belongs_to :branch_node, :foreign_key=>"branch_node_id", :polymorphic=>true
end
