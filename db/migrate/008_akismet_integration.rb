class AkismetIntegration < ActiveRecord::Migration
  def self.up
    add_column :nodes, :content_status, :enum, :limit => [:spam, :ham]
  end

  def self.down
    remove_column :nodes, :content_status
  end
end
