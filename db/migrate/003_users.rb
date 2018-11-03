class Users < ActiveRecord::Migration
  def self.up
     create_table :authors do |t|
        t.column :name, :string
        t.column :url, :string
        t.column :email, :string
        t.column :created_at, :datetime
        t.column :updated_at, :datetime
        t.column :login, :string 
        t.column :hashed_password, :string
        t.column :salt, :string
        t.column :type, :string
        t.column :sponsor_id, :int
     end
  end

  def self.down
     drop_table :authors
  end
end
