class Token < ActiveRecord::Base
  belongs_to :node

  def verify(password)
    return verify_with_immortality(password) #unless self.created_at.iso8601 < Time.now.ago(Token.lifetime).iso8601
    #return false
  end

  def verify_with_immortality(password)
    #return token == Digest::SHA1.hexdigest(self.created_at.iso8601.to_s + self.nonce + password)
    return token == Digest::SHA1.hexdigest(self.nonce + password)
  end
  
  def generate_token(password)
    self.created_at ||= Time.now
    self.nonce ||= Token.random_string(20)

    #token = Token.find(:first, :conditions=>["nonce=? and created_at>?", self.nonce, self.created_at.ago(Token.lifetime)])
    token = Token.find(:first, :conditions=>["nonce=?", self.nonce])
    while token
      self.nonce = Token.random_string(self.nonce.length+1)
    end

    #self.token = Digest::SHA1.hexdigest(self.created_at.iso8601.to_s + self.nonce + password)
    self.token = Digest::SHA1.hexdigest(self.nonce + password)
  end

  def renew(password)
    self.created_at = nil
    self.nonce = nil
    self.generate_token(password)
  end

  def Token.lifetime
    10.minutes
  end

  def Token.nonce_length
    20
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
