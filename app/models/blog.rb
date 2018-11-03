class Blog < ActiveRecord::Base
  has_many :nodes
  
  has_many :published_nodes, :class_name=>'Node', :conditions=>"(not published_at is null) and (published_at <= NOW()) and (content_status is null or not content_status in ('Spam'))"
  
  has_many :posts, :conditions=>["parent_id is null and (not published_at is null) and (published_at <= NOW()) and (content_status is null or not content_status in ('Spam'))"], :order=>"published_at desc"
  has_many :drafts, :class_name=>'Post', :conditions=>["published_at is null", Time.now], :order=>"published_at desc"
  
  has_many :all_posts, :class_name=>'Post', :order=>"published_at desc"
  
  has_many :comments, :conditions=>"(not parent_id is null) and (not published_at is null) and (published_at <= NOW()) and (content_status is null or not content_status in ('Spam'))", :order=>"published_at desc"
  has_many :authors, :through=>:nodes
  
  has_and_belongs_to_many :editors

  attr_reader :config
  
  validates_uniqueness_of :domain, :message=>'Another blog is already using this domain.'
  
  before_save :serialise_config_hash
  
  
  def config
    @config = {} if self.config_hash.nil?
    @config ||= (YAML::load(self.config_hash) || {})
  end
  
  def serialise_config_hash
    self.config_hash = @config.to_yaml if @config
  end
  
  def published_posts(num = nil)
    return nodes.find(:all, :conditions=>["parent_id is null and (not published_at is null) and published_at <= ?", Time.now], :order=>"published_at desc", :limit=>num)
  end

  def tags
    Tag.find_by_sql("select tags.id, tags.name, count(*) as count from tags inner join nodes_tags t on t.tag_id = tags.id inner join nodes n on t.node_id = n.id where n.blog_id=#{id}  group by tags.id, tags.name order by tags.name")
  end
  
  def current_theme
    Theme.find(theme)
  end
end
