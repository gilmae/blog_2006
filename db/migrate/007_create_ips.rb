class CreateIps < ActiveRecord::Migration
  def self.up
    create_table :ips do |t|
      t.column :ip, :string
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
      t.column :spam_attempts, :integer 
    end

    add_column :nodes, :ip_id, :integer
  end

  def self.down
    drop_table :ips
    remove_column :nodes, :ip_id
  end
end
