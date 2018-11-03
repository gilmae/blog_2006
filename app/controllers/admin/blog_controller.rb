class Admin::BlogController < Admin::BaseController
  before_filter :check_logged_in
  before_filter :determine_current_blog, :except=>[:fresh_install?, :check_logged_in, :login, :new]

  layout 'admin'
  
  def new
    if request.get?
      @blog = Blog.new
      @blog.domain = request.host_with_port
      @blog.editors << current_user
    elsif request.post?
      @blog = Blog.new(params[:blog])
      
      if @blog.save
        flash[:saved] = "Your blog has been saved."
        redirect_to :action=>:show, :id=>@blog.id
      end
    end  
  end

  def index
    @blogs = Blog.paginate(:page => params[:page], :order=>"Name")
  end

  def show
    @blog = Blog.find(params[:id])
    @latest_posts = @blog.posts.find(:all, :limit=>5)
    @latest_commenters = @blog.authors.find(:all, :select=>"distinct authors.*", :limit=>5, :order=>'created_at desc')
  end

  def delete
    if request.post? || request.delete?
      Blog.destroy(params[:id])
      clear_current_blog if @current_blog.id = params[:id]
    end
    
    redirect_to :action=>:index
  end

  def edit
    if request.get?
      @blog = Blog.find(params[:id])
    elsif request.post?
      @blog = Blog.find(params[:id]) if params[:id]
      
      @blog.attributes = params[:blog]
      
      if @blog.save
        flash[:saved] = "Your blog has been saved."
        redirect_to :action=>:show, :id=>@blog.id
      end
    end  
  end
end
