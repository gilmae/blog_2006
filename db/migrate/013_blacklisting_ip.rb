class BlacklistingIp < ActiveRecord::Migration
  def self.up
    remove_column :ips, :spam_attempts
    add_column :ips, :is_blacklisted, :bool, :default=>false
  end

  def self.down
    add_column :ips, :spam_attempts, :int
    remove_column :ips, :is_blacklisted
  end
end
