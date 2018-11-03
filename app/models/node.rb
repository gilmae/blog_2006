require 'uri'

class Node < ActiveRecord::Base
  attr_protected :type, :permalink, :comments_closed, :content_status, :ip_id
  belongs_to :author
  belongs_to :ip
  belongs_to :blog
  has_and_belongs_to_many :tags

  acts_as_threaded :order=>"published_at", :conditions=>"(not published_at is null) and (published_at <= NOW()) and (content_status is null or not content_status in ('Spam'))"

  before_save :generate_permalink
 
  after_destroy :prune_children

  validates_presence_of :body, :message=>"You must have something to say in order to post."
  validates_presence_of :title, :message=>"You need to call it something."
  validates_length_of :title, :maximum=>128, :message=>"Title is too long to store correctly"
  validates_associated :author, :ip, :blog
  
  def published?
    !self.published_at.nil?  && self.published_at <= Time.now
  end
  
  def publish!
    publish
    save
  end
  
  def publish
    self.published_at = Time.now
  end
  
  def uri
    "http://" + blog.domain + "/" + permalink
  end

  def self.generate_permalink(date, title)
    temp_plink = date.strftime("%Y/%m/%d/") + title.gsub(/[^\w\d]/, "_")
  
    while !Node.unique_permalink?(temp_plink)
      temp_plink+="_"
    end
    return temp_plink 
  end

  def self.published_posts(num = nil)
    return Node.find(:all, :conditions=>["parent_id is null and (not published_at is null ) and published_at <= ?", Time.now], :order=>"published_at desc", :limit=>num)
  end

  def self.find_by_published_date options
    clause = []
    args = []
    clause << "Year(published_at)=#{sanitize_sql(options[:year])}" if options.has_key? :year
    clause << "Month(published_at)=#{sanitize_sql(options[:month])}" if options.has_key? :month
    clause << "DayOfMonth(published_at)=#{sanitize_sql(options[:day])}" if options.has_key? :day
    
    sql = "SELECT * FROM nodes "
    sql << "WHERE 1=1 "
    sql << "AND #{sanitize_sql(options[:conditions])} " if options[:conditions]
    sql << "and (" + clause.join(" and ") + ")"
    sql << "ORDER BY #{options[:order]} " if options[:order]
    sql << "LIMIT #{options[:limit]} " if options[:limit]

    Node.find_by_sql(sql)
  end
  
  def Node.find_by_permalink_and_blog_id permalink, blog_id
    Node.find(:first, :conditions=>["permalink=? and blog_id=?", permalink, blog_id])
  end
  
 def Node.find_by_permalink permalink
    Node.find(:first, :conditions=>["permalink=?", permalink])
  end

  def tag_uri
    "tag:avocadia.net,#{created_at.strftime("%Y-%m-%d")}:/#{permalink}"
  end

  def allow_followup?
    return (!self.comments_closed) && (self.published_at) && self.published_at > Time.now.ago(90.days)
  end
  
  def close_comments
    self.comments_closed = true
    self.save

  end

  def prune_children
    Node.destroy_all ["parent_id = ?", self.id] 
  end

  def generate_permalink
    self.permalink = Node.generate_permalink(self.published_at, self.title) if self.published_at && self.title && (self.new_record? || !self.permalink)
  end
  
  def validate
    #errors.add :parent, "Cannot followup that node as it is now closed." if parent && !parent.allow_followup?
    #errors.add :ip, "You are posting from an IP address that has been banned due to spamming." if (self.ip && self.ip.blacklisted?)
  end
  
  def tag_with(list)
    Tag.transaction do
      tags.destroy_all

      Tag.parse(list).each do |name|
        tags << Tag.find_or_create_by_name(name)
      end
    end
  end
  
  def self.unique_permalink? (plink)
    nodes = Node.find_by_permalink(plink)
    nodes.nil? || !nodes.kind_of?(Node)# || nodes.empty?)  
  end
end
  