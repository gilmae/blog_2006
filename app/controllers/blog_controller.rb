class BlogController < ContentController
  
  helper 'template/blog'
  helper 'template/node'
  helper 'template/feed'
  helper 'template/comment'  
  
  caches_page :index, :archive_page, :individual_page, :followup
  cache_sweeper :node_sweeper, :only => [ :followup ]
  
  def current_node
    (@node_stack||=[]).last
  end
  
  def index
    @context.nodes = current_blog.posts.paginate(:all, :page => params[:page], :per_page => 10, :order=>"published_at desc", :include=>[:author, :tags])
    render_themed_page :index
  end
  
  def archive_page
    @context.nodes = current_blog.posts.paginate(:all, :conditions=>["permalink like ?", [params[:year], params[:month], params[:day]].reject{|item| !item}.join("/") + "/%"], :page => params[:page], :per_page => 10, :order=>"published_at desc", :include=>[:author, :tags])
    render_themed_page :archive
  end
  
  def tag_archive
    tag = Tag.find_by_name(params[:tag])
    if tag.nil?
      render :file => "#{RAILS_ROOT}/public/404.html",  :status => 404 and return 
    end
    
    @context.nodes = tag.nodes.paginate(:all, :conditions=>["blog_id=?", current_blog.id], :page => params[:page], :per_page => 10, :order=>"published_at desc", :include=>[:author])
    render_themed_page :archive
  end
  
  def individual_page
    @context.nodes = current_blog.published_nodes.find(:all, :conditions=>["permalink=?", [params[:year], params[:month], params[:day], params[:title]].reject{|item| !item}.join("/")], :include=>[:author, :tags])
    
    if @context.nodes.empty?
      (render_error_page(404) and return) 
    else  
      render_themed_page :individual
    end
  end

  def viewnode
    @context.nodes = [current_blog.published_nodes.find(params[:id])]
    render_themed_page :individual
  end

  def followup
    @context.blog = current_blog
    @node = Comment.new(params[:node])

    if request.get?
      parent = Node.find_by_permalink_and_blog_id(URI.encode(params["year"] + "/" + params["month"] + "/" + params["day"] + "/" + params["title"]), current_blog.id)
      (render_error_page(404) and return)  unless parent
      
      @node.parent_id = parent.id
    
      @node.author, @remember_as_cookie = saved_author

      @node.title = ("re: " + parent.title.gsub(/(re:\s)/, "")) if (!@node.title || @node.title=="")
    else
      @node.author = Author.find_or_create_by_name_and_url(params[:author][:name], params[:author][:url])
      @node.author.email = params[:author][:email] if params[:author][:email]
      @remember_as_cookie = params["remember_me"] == "on"
      parent = Node.find(@node.parent_id)
    
      (render_error_page(404) and return) unless parent
    end
    
    (redirect_to(parent.permalink) and return) unless parent.allow_followup?

    @context.node_stack.push parent
    @context.comment = @node

    if request.post? && (params[:command] == "post" || params[:command] == "save") 
      @node.ip = Ip.find_by_ip(request.remote_ip) || Ip.new({:ip=>request.remote_ip})
      
      @node.blog_id = @context.blog.id
      @node.published_at = Time.now
      
      if @node.save
        @remember_as_cookie?save_author_as_cookie(@node.author):forget_author_cookie
        redirect_to url_for("/" + @node.permalink)
      else
        render_themed_page :followup
      end  
    else
      render_themed_page :followup
    end   
  end
end
