class ContentController  < ApplicationController
  #include ExceptionNotifiable
  attr_accessor :context
  before_filter :build_context

  before_filter :current_blog
  
  def current_blog
    @current_blog_by_url ||= Blog.find_by_domain(request.host_with_port)
  end

  def save_author_as_cookie author
    if author
      cookie_expiry = Time.now.since(90.days)
      cookies["name"] = {:value=>author.name, :expires=>cookie_expiry}
      cookies["url"] = {:value=>author.url, :expires=>cookie_expiry}
      cookies["email"] = {:value=>author.email, :expires=>cookie_expiry}
    end
  end
  
  def forget_author_cookie
      cookie_expiry = Time.now.ago(1.second)
      cookies["name"] = {:value=>"", :expires=>cookie_expiry}
      cookies["url"] = {:value=>"", :expires=>cookie_expiry}
      cookies["email"] = {:value=>"", :expires=>cookie_expiry}
  end

  def saved_author
    author = nil
    if cookies["name"] && cookies["url"]
      author = Author.find_by_name_and_url(cookies["name"], cookies["url"])
    else 
      author = Author.new
      author.name = cookies["name"] if cookies["name"]
      author.url = cookies["url"] if cookies["url"]
      author.email = cookies["email"] if cookies["email"]
    end
    return author, !author.new_record?
  end
  
  def build_context
    @context = Context.new(current_blog)
    session[:ip] = request.remote_ip
    
    @context.page = request.include?("page")?(request["page"].to_i):1
  end 

  def themed_layout
    (current_blog.theme)?("../../themes/#{current_blog.theme}/blog"):""
  end
  
  def render_themed_page template
    render :file=> "#{@context.blog.current_theme.path}/#{template}.erb", :layout=>themed_layout
  end
  
  def render_error_page status
    if File.exists? "#{@context.blog.current_theme.path}/#{status}.erb" then
       render :file=> "#{@context.blog.current_theme.path}/#{status}.erb", :status=>status, :layout=>themed_layout
    else
       render :file => "#{RAILS_ROOT}/public/#{status}.html",  :status => status and return 
    end
  end
end