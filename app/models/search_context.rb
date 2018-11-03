class Search_Context < Context
 attr_accessor :search_query
 
 def get_nodes
    return @nodes if !@nodes.empty?
    
    date_params = []
    date_params << :year if :year
    date_params << :month if :year
    date_params << :day if :day
    
    Node.find_by_contents(@search_qry, :limit=>@limit, :offset=>cur_page_offset*@limit).select{|ii| ii.blog_id == @blog.id}
  end
  
  def max_page
    return @max_pages if @max_pages
    
    date_params = []
    date_params << :year if :year
    date_params << :month if :year
    date_params << :day if :day

    @max_pages=((Node.find_by_contents(@search_qry).select{|ii| ii.blog_id == @blog.id})/@limit.to_f).ceil
  end
end