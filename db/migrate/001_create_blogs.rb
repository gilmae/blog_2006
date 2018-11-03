class CreateBlogs < ActiveRecord::Migration
  def self.up
    create_table :blogs do |t|
      t.column :name, :string
      t.column :sub_title, :string
      t.column :description, :string
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
      t.column :domain, :string
      t.column :theme, :string
    end
  end

  def self.down
    drop_table :blogs
  end
end
