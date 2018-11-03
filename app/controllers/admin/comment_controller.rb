class Admin::CommentController < Admin::BaseController
  before_filter :check_logged_in
 
  layout 'admin'
  
  def index
    if request.get?
     @nodes = Comment.paginate(:page => params[:page], :conditions=>["blog_id=? and (content_status is null or content_status <> ?)", current_blog.id, :spam], :order=>'published_at desc')
    end
  end
  
  def show
    @node = current_blog.nodes.find(params[:id])  
  end

  def edit
    @node = current_blog.nodes.find(params[:id])
    redirect_to(:action=>:index) if !@node  
    
    if request.post?
      if params[:node][:cmd] == "Cancel"
        redirect_to :action=>:show, :id=>@node.id
      else  
        new_attrs = params[:node]
        @node.attributes = new_attrs
        @node.content_status = new_attrs[:content_status]
        @node.comments_closed = new_attrs[:comments_closed]
        
        if @node.save
          redirect_to :action=>:show, :id=>@node.id
        end
      end
    end  
  end
  
  def save
    #@node = current_blog.nodes.find(params[:id])  
    redirect_to :action=>:edit, :id=>paams[:id]
  end
  
  def delete
     user = current_user
     if user 
        if request.post?
          Node.destroy(params["id"])
        end
     end
     redirect_to :action=>"index"
  end 
  
  def check_akismet
    @node = Comment.find(params[:id])
    if @node
      @node.check_akismet!
      redirect_to :action=>:edit, :id=>@node.id
    else
      redirect_to :action=>:index 
    end
  end
  
  def mark_as_spam
    @node = Comment.find(params[:id])
    if @node
      @node.mark_as_spam!
      redirect_to :action=>:show, :id=>@node.id      
    else
       redirect_to :action=>:index
    end
  end
    
  def mark_as_ham
    @node = Comment.find(params[:id])
    if @node
      @node.mark_as_ham!
      redirect_to :action=>:show, :id=>@node.id
    else
       redirect_to :action=>:index
    end
  end
end
