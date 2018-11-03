class ArchiveContext < Context
  attr_accessor :year, :month, :day
  
  def get_nodes
    return @nodes if !@nodes.empty?

    @date_params = gather_params
    
    @nodes = Post.find(:all, :conditions=>["permalink like ? and blog_id=?", @date_params.join("/")+"%", @blog.id], :limit=>@limit, :offset=>cur_page_offset*@limit, :include=>[:tags, :author]) if !@date_params.empty?
  end
  
  def max_page
    return @max_pages if @max_pages
    
    
    @date_params = gather_params

    @max_pages=(Post.count(:id, :conditions=>["permalink like ? and blog_id=?", @date_params.join("/")+"%", @blog.id])/@limit.to_f).ceil
  end
  
  def initialize blog, year, month, day
    super blog
    @year = year
    @month = month
    @day = day
  end
  
  def gather_params
    params ||= []
    return params if !params.empty?
    
    params << @year if @year
    params << @month if @month
    params << @day if @day
    
    params
  end
end


