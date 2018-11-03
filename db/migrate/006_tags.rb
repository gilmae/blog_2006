class Tags < ActiveRecord::Migration
  def self.up
     create_table :tags do |t|
        t.column :name, :string  
     end

     create_table :nodes_tags, :id=>false  do |t|
        t.column :tag_id, :int
        t.column :node_id, :int
     end


  end

  def self.down
     drop_table :tags
     drop_table :nodes_tags
  end
end

