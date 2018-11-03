#class PublicationController < ApplicationController
#  before_filter :check_logged_in
#
#  before_filter :determine_blog
#
#  helper :blog, :tag
#  layout "blog"
#  
#  def drafts
#    @pages, @nodes = paginate(:nodes, :conditions=>["blog_id=? and parent_id is null and published_at is null", @blog.id])
#    render :template=>"/publication/drafts", :layout=>"admin"
#  end
#
#  def node
#    @node = @blog.nodes.build
#    @node = Node.find(params[:id]) if params[:id]
#    @node.author_id ||= session[:user]
#    
#    if request.post?
#      @node.attributes = params[:node]
#      
#      self.send(params[:command])
#    end
#  end
#  
#  alias post node
#  alias edit node
#
#  def publish
#    if request.post?
#      #@node = Node.new(params[:node])
#      @node.tag_with params[:tag_list]
#      
#      @node.publish
#      
#      @node.save
#    end
#  end
#
#  def save
#    if request.post?
#      #@node = Node.new(params[:node])
#      @node.tag_with params[:tag_list]
#     
#      @node.save
#    end  
#  end
#  
#  def recall
#    @node = Node.find(params[:id])
#    if @node && request.post?
#      @node.published_at = nil
#      @node.save
#    else
#      redirect_to "/"
#    end  
#  end
#  
#  def close
#    @node = Node.find(params[:id])
#    if @node && request.post?
#      @node.close_comments
#      @node.save
#    else
#      redirect_to "/"
#    end  
#  end
#
#  def remove
#    @node = Node.find(params[:id])
#    if @node && request.post?
#      Node.destroy(params["id"])
#    end
#  end
#end
