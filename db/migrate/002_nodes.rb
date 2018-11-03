class Nodes < ActiveRecord::Migration
  def self.up
     create_table :nodes do |t|
        t.column :title, :string
        t.column :body, :text
        t.column :precis, :text
        t.column :created_at, :datetime
        t.column :updated_at, :datetime
        t.column :published_at, :datetime 
        t.column :parent_id, :int
        t.column :permalink, :string
        t.column :author_id, :int
        t.column :comments_closed, :boolean
        t.column :blog_id, :integer
     end 
  end

  def self.down
     drop_table :nodes
  end
end
