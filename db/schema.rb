# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 13) do

  create_table "Threading", :primary_key => "ThreadingID", :force => true do |t|
    t.integer "ThreadID"
    t.integer "BlockID"
  end

  create_table "authors", :force => true do |t|
    t.string   "name"
    t.string   "url"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "login"
    t.string   "hashed_password"
    t.string   "salt"
    t.string   "type"
    t.integer  "sponsor_id"
  end

  add_index "authors", ["url"], :name => "index_authors_on_url"
  add_index "authors", ["name", "url"], :name => "index_authors_on_name_and_url"
  add_index "authors", ["type"], :name => "index_authors_on_type"

  create_table "blogs", :force => true do |t|
    t.string   "name"
    t.string   "sub_title"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "domain"
    t.string   "theme"
    t.text     "config_hash"
  end

  add_index "blogs", ["domain"], :name => "index_blogs_on_domain"

  create_table "blogs_editors", :id => false, :force => true do |t|
    t.integer "blog_id"
    t.integer "editor_id"
  end

  add_index "blogs_editors", ["blog_id", "editor_id"], :name => "index_blogs_editors_on_blog_id_and_editor_id"

  create_table "ips", :force => true do |t|
    t.string   "ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_blacklisted", :default => false
  end

  add_index "ips", ["ip"], :name => "index_ips_on_ip"

  create_table "nodes", :force => true do |t|
    t.string   "title"
    t.text     "body"
    t.text     "precis"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "published_at"
    t.integer  "parent_id"
    t.string   "permalink"
    t.integer  "author_id"
    t.boolean  "comments_closed"
    t.integer  "blog_id"
    t.integer  "ip_id"
    t.enum     "content_status",  :limit => [:none, :ham, :unknown, :spam]
    t.string   "type"
  end

  add_index "nodes", ["published_at"], :name => "index_nodes_on_published_at"
  add_index "nodes", ["parent_id"], :name => "index_nodes_on_parent_id"
  add_index "nodes", ["blog_id"], :name => "index_nodes_on_blog_id"
  add_index "nodes", ["author_id"], :name => "index_nodes_on_author_id"
  add_index "nodes", ["permalink"], :name => "index_nodes_on_permalink"

  create_table "nodes_tags", :id => false, :force => true do |t|
    t.integer "tag_id"
    t.integer "node_id"
  end

  add_index "nodes_tags", ["tag_id"], :name => "index_nodes_tags_on_tag_id"
  add_index "nodes_tags", ["node_id"], :name => "index_nodes_tags_on_node_id"

  create_table "oldnodes", :primary_key => "nodeID", :force => true do |t|
    t.string  "nodeTitle",   :limit => 100
    t.text    "nodeBody"
    t.text    "nodePrecise"
    t.string  "datetime",    :limit => 14
    t.string  "nodeType",    :limit => 1
    t.integer "parentNode"
    t.integer "nextSibling",                :default => -1
    t.integer "prevSibling",                :default => -1
    t.integer "childNodes"
    t.integer "threadID",                   :default => -1
    t.integer "FirstChild",                 :default => -1
    t.integer "LastChild",                  :default => -1
    t.integer "postedBy"
    t.integer "public",                     :default => 1
    t.string  "Edited",      :limit => 1,   :default => ""
    t.integer "Pings",                      :default => 0
  end

  create_table "taggings", :force => true do |t|
    t.integer "tag_id"
    t.integer "taggable_id"
    t.string  "taggable_type"
  end

  add_index "taggings", ["taggable_type"], :name => "tagging_taggable_type_index"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "thread_branches", :id => false, :force => true do |t|
    t.integer "thread_id"
    t.integer "branch_node_id"
    t.string  "branch_node_type"
    t.string  "thread_type"
    t.integer "levels_from_root"
  end

  add_index "thread_branches", ["thread_id"], :name => "index_thread_branches_on_thread_id"
  add_index "thread_branches", ["branch_node_id"], :name => "index_thread_branches_on_branch_node_id"

  create_table "tokens", :force => true do |t|
    t.string   "nonce"
    t.datetime "created_at"
    t.string   "token"
  end

  create_table "users", :primary_key => "counter", :force => true do |t|
    t.string  "userID",   :limit => 20
    t.string  "password", :limit => 20
    t.string  "userName", :limit => 30
    t.string  "email",    :limit => 100
    t.string  "url",      :limit => 100
    t.integer "admin",    :limit => 4
    t.integer "trusted",  :limit => 4,   :default => 0
  end

  add_index "users", ["url"], :name => "index_users_on_url"

end
