require 'digest/sha1'

class Editor < Author
  
  has_and_belongs_to_many :blogs
  has_many :posts, :foreign_key=>"author_id", :class_name=>'Node', :conditions=>["parent_id is null and (not published_at is null) and published_at <= ?", Time.now], :order=>"published_at desc"
  
  attr_accessor :password, :password_confirmation
  attr_protected :type, :password, :password_confirmation

  validates_presence_of :login, :email, :salt, :name, :hashed_password
  validates_uniqueness_of :login
  validates_length_of :login, :within=>6..40
  validates_length_of :password, :within=>6..128, :allow_nil=>true
  validates_confirmation_of :password

  def password=(value)
    @password=value
    self.salt = Editor.random_string(10) if !self.salt?
    self.hashed_password = Editor.encrypt(@password, self.salt)
  end

  def authenticate(pass)
    return Editor.encrypt(pass, self.salt)==self.hashed_password
  end
  
  def self.authenticate(login, pass)
    u = find(:first, :conditions=>["login=?", login])
    return nil if u.nil?
    return u if u.authenticate(pass)
    nil
  end

  protected

  def self.random_string(len)
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."0").to_a
    newsalt = ""
    1.upto(len){|ii| newsalt << chars[rand(chars.size-1)]}
    return newsalt
  end

  def self.encrypt(pass, salt)
    Digest::SHA1.hexdigest(pass+salt)
  end
end