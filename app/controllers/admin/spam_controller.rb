class Admin::SpamController <Admin::CommentController

  def index
    if request.get?
     @nodes = Comment.paginate(:page => params[:page], :conditions=>["blog_id=? and content_status = ?", current_blog.id, :spam], :order=>'published_at desc')
    end
  end
  
  def show
    @node = current_blog.nodes.find(params[:id])  
  end
end
