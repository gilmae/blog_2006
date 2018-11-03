class ThreadContext < ArchiveContext
  attr_accessor :title
  
  def get_nodes
    return @nodes if !@nodes.empty?

    @date_params = gather_params
    
    @nodes = Node.find(:all, :conditions=>["permalink=? and blog_id=?", @date_params.join("/"), @blog.id], :limit=>@limit, :offset=>cur_page_offset*@limit, :include=>[:tags, :author]) if !@date_params.empty?
  end
  
  def max_page
    return @max_pages if @max_pages
    
    
    @date_params = gather_params

    @max_pages=(Node.count(:id, :conditions=>["permalink=? and blog_id=?", @date_params.join("/"), @blog.id])/@limit.to_f).ceil
  end
  
  def initialize blog, year, month, day, title
    super blog, year, month, day
    @title = title
  end
  
  def gather_params
    params ||= []
    return params if !params.empty?
    
    params << @year
    params << @month
    params << @day
    params << @title
    
    params
  end
end


