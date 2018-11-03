class BlogsEditors < ActiveRecord::Migration
  def self.up
    create_table :blogs_editors, :id=>false do |t|
      t.column :blog_id, :int
      t.column :editor_id, :int
    end
  end

  def self.down
    
    drop_table :blogs_editors
  end
end
