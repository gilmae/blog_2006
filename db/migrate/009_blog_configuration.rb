class BlogConfiguration < ActiveRecord::Migration
  def self.up
    add_column :blogs, :config_hash, :text
  end

  def self.down
    remove_column :blogs, :config_hash
  end
end
