class Threading < ActiveRecord::Migration
  def self.up
     create_table "thread_branches", :id=>false, :force=>true do |t|
        t.column "thread_id", :int
        t.column "branch_node_id", :int
        t.column "branch_node_type", :string
        t.column "thread_type", :string
        t.column "levels_from_root", :int
     end 
  end

  def self.down
     drop_table :thread_branches
  end
end
