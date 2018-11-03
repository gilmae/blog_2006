class Author < ActiveRecord::Base
  has_many :nodes
  has_many :ips, :through=>:nodes

  attr_protected :type, :password, :password_confirmation

  validates_presence_of :name, :message=>"Please enter a name"
  validates_length_of :name, :maximum=>64, :message=>"Name is too long to store correctly"

  validates_length_of :url, :allow_nil=>true, :maximum=>128, :message=>"Url is too long, try http://tinyurl.com or similar"
  validates_length_of :email, :allow_nil=>true, :maximum=>128, :message=>"Email is too long to store correctly"

  after_destroy :prune_nodes

  #private

  def prune_nodes
    Node.destroy_all ["author_id = ?", self.id] 
  end
end

