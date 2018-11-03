class CommentSubtype < ActiveRecord::Migration
  def self.up
    add_column :nodes, :type, :string
    Node.update_all("type='Comment'", 'not parent_id is null')
    Node.update_all("type='Post'", 'parent_id is null')
  end

  def self.down
    remove_column :nodes, :type
  end
end
