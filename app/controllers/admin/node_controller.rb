class Admin::NodeController < Admin::BaseController
  before_filter :check_logged_in

  helper :blog
  layout "admin"
  
  def index
     @nodes = Post.paginate(:page => params[:page], :order=>["published_at desc"], :conditions=>["blog_id=?", @current_blog.id])
  end
  
  def drafts
     @nodes = Post.paginate(:page => params[:page], :conditions=>["blog_id=? and published_at is null", @current_blog.id])
     render :template=>"/admin/node/index", :layout=>"admin"
  end

  def published
      @nodes = Post.paginate(:page => params[:page], :order=>"published_at desc", :conditions=>["blog_id=?  and (not published_at is null)", @current_blog.id])
     render :template=>"/admin/node/index", :layout=>"admin"
  end
  
  def node
    @node = @current_blog.posts.build
    @node = Node.find(params[:id]) if params[:id]
    @node.author_id ||= session[:user]
    
    if request.post?
      @node.attributes = params[:node]
      @node.published_at = (@node.published_at.strftime("%m/%d/%Y") + 'T' + params['publish_at_time']) if @node.published_at && params['publish_at_time']
      @node.comments_closed = params[:node][:comments_closed]
       
      self.send(params[:command])
    end
    
    render :template=>"admin/node/show" unless params[:command]
  end

  def save
     if request.post?
       #@node = Node.new(params[:node])
       @node.tag_with params[:tag_list]
       @node.save
       
       redirect_to("/node/node/#{@node.id}") and return false
     end
  end
  
  def delete
    @node = Node.find(params[:id])
    if @node && request.post?
      Node.destroy(params["id"])
    end
    redirect_to :action=>'index' and return false
  end
  
  def preview
    render :template=>"admin/node/show" and return false
  end
  
  def close_thread
    @node = Node.find(params[:id])
    if @node
      @node.comments_closed = true
      @node.save
      @node.descendants.each do |node|
        node.comments_closed = true
      end
      @node.save
      render :template=>"admin/node/show" and return false
    else
     render :template=>"admin/node" and return false
    end   
  end
end
