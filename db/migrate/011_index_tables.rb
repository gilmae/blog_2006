class IndexTables < ActiveRecord::Migration
  def self.up
    add_index :nodes, :published_at
    add_index :nodes, :parent_id
    add_index :nodes, :blog_id
    add_index :nodes, :author_id
    add_index :nodes, :permalink
    
    add_index :authors, :url
    add_index :authors, [:name, :url]
    add_index :authors, :type
    
    add_index :blogs_editors, [:blog_id, :editor_id]
    
    add_index :blogs, :domain
    
    add_index :thread_branches, :thread_id
    add_index :thread_branches, :branch_node_id
    
    add_index :nodes_tags, :tag_id
    add_index :nodes_tags, :node_id
    
    add_index :ips, :ip
  end

  def self.down
    remove_index :nodes, :published_at
    remove_index :nodes, :parent_id
    remove_index :nodes, :blog_id
    remove_index :nodes, :author_id
    remove_index :nodes, :permalink
    
    remove_index :authors, :url
    remove_index :authors, [:name, :url]
    remove_index :authors, :type
    
    remove_index :blogs_editors, [:blog_id, :editor_id]
    
    remove_index :blogs, :domain
    
    remove_index :thread_branches, :thread_id
    remove_index :thread_branches, :branch_node_id
    
    remove_index :nodes_tags, :tag_id
    remove_index :nodes_tags, :node_id
    remove_index :ips, :ip
  end
end
