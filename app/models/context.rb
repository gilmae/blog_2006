class Context
  attr_accessor :feeds, :page, :permalink, :nodes, :blog, :node_stack, :limit, :comment, :search_qry, :ip, :thread, :tag
  
  def initialize blog
    @feeds = []
    @nodes = []
    @blog = blog
    @node_stack = []
    @conditions = nil
    @page = 1
    @limit=10
  end
  
  def cur_node
     @node_stack.last
   end
   
  def cur_page
    @page
  end
    
  def cur_page_offset
    @page>0 ? @page-1 : 0
  end
  
  def get_nodes
    return @nodes
    
  end

  def more_pages?
    cur_page < max_page
  end
  
  def max_page
    return @max_pages if @max_pages
    
    if @permalink
      conditions = ["permalink like ? and blog_id=?", @permalink, @blog.id]
    else
     conditions = ["blog_id=?", @blog.id]
    end
 
    if @search_qry
      @nodes ||= Node.find_by_contents(@search_qry).length
      @max_pages=(@nodes.length/@limit.to_f).ceil
    elsif @tag
      @max_pages=(Tag.find_by_name(@tag).nodes.count(:id, :conditions=>conditions)./@limit.to_f).ceil
    else
      @max_pages=(Post.count(:id, :conditions=>conditions)/@limit.to_f).ceil
    end
    @max_pages
  end
end