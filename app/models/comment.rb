class Comment < Node
  validates_columns :content_status

#  def parent_allows_followups
#    errors.add :parent, "Cannot followup that node as it is now closed." if parent && !parent.allow_followup?
#  end
#  
#  def ip_not_blacklisted
#    errors.add :ip, "You are posting from an IP address that has been banned due to spamming." if (self.ip && self.ip.blacklisted?)
#  end
  
  def akismet
    Akismet.new(AKISMET_API_KEY, "http://" + blog.domain)
  end

  def check_akismet!
    return true if RAILS_ENV == "development"
    return nil if !content_status.nil?
    return false if AKISMET_API_KEY.blank?
    
     begin
      Timeout.timeout(defined?($TESTING) ? 30 : 60) do
        self.content_status=:spam if akismet.commentCheck(((ip.nil?)?'':ip.ip), 'Akismet Ruby API/1.0', '', parent.permalink, self.class.to_s.downcase, author.name, author.email, author.url, body, {})
      end
    rescue Timeout::Error => e
      nil
    end
    
    save
  end
  
  def mark_as_ham!
    self.content_status = :ham
    save
    return true if RAILS_ENV == "development"
    if !AKISMET_API_KEY.blank?
      akismet.submitHam(((ip.nil?)?'':ip.ip), 'Akismet Ruby API/1.0', '', parent.permalink, self.class.to_s.downcase, author.name, author.email, author.url, body, {})
    end
  end
  
    def mark_as_spam!
    self.content_status = :spam
    save
    return true if RAILS_ENV == "development"
    if !AKISMET_API_KEY.blank?
      akismet.submitHam(((ip.nil?)?'':ip.ip), 'Akismet Ruby API/1.0', '', parent.permalink, self.class.to_s.downcase, author.name, author.email, author.url, body, {})
    end
  end
end
