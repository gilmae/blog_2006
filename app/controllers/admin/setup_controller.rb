class Admin::SetupController < Admin::BaseController
  before_filter :fresh_install?, :except=>[:index, :editor, :blog]
  before_filter :check_logged_in, :except=>[:index, :editor, :blog]
  before_filter :determine_current_blog, :except=>[:index, :editor, :blog]

  layout 'admin'
  
  def index
    @requires_editor = Editor.count == 0
  end

  def editor
    @editor = Editor.new(params[:editor])
    
    if request.post?
      @editor.password = params[:editor][:password] ## Why do I need to do this step?!?
      
      if (@editor.save)
        force_login @editor
        redirect_to(:action=>'blog') 
      end
    end
  end

  def blog
    @blog = Blog.new(params[:blog])
    @blog.domain ||= request.host_with_port
    
    if request.post?
      @blog.editors << current_user
      redirect_to(:controller=>'base', :action=>'console') if @blog.save
    end
  end
end
