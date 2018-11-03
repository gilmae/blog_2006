class FurtherCommentContentStatuses < ActiveRecord::Migration
  def self.up
    change_column(:nodes, :content_status, :enum, :limit => [:none, :ham, :unknown, :spam])
  end

  def self.down
    change_column(:nodes, :content_status, :enum, :limit => [:spam, :ham])
  end
end
