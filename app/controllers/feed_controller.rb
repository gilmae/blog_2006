class FeedController < ContentController

  helper 'template/blog'
  helper 'template/node'
  helper 'template/feed'
  helper 'template/comment'  

  def main
    @context.nodes = current_blog.posts.find(:all, :limit => 10, :order=>"published_at desc", :include=>[:author, :tags])
    
    @updated_at = @context.nodes[0].published_at
  end

  def comments
     @context.nodes = current_blog.comments.find(:all, :order=>"published_at desc", :limit=>15)

     @updated_at = @context.nodes[0].published_at
  end

  def thread
    @context.nodes = []
    @updated_at = Time.now
    
    if params["year"].nil? || params["month"].nil? || params["day"].nil? || params["title"].nil?
     render :nothing => true, :status=>404 and return 
    end
    
    parent =  current_blog.nodes.find_by_permalink(params["year"] + "/" + params["month"] + "/" + params["day"] + "/" + params["title"])
    
    if parent
      @updated_at = parent.published_at
      @context.nodes = parent.descendants
      
      @updated_at = @context.nodes[0].published_at if !@context.nodes.empty?
      @context.blog = current_blog
    else
      render :nothing => true, :status=>404 and return 
    end  
  end
end
