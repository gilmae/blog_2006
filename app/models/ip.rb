class Ip < ActiveRecord::Base
  has_many :nodes
  has_many :authors, :through=>:nodes, :uniq=>true
  
  def blacklisted?
    is_blacklisted
  end
  
  def spams
    nodes.count(:conditions=>["content_status=?", :spam])
  end
  
  
end
