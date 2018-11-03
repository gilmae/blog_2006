class Admin::BaseController < ApplicationController
  attr_accessor :current_blog, :current_user
  before_filter :fresh_install?, :except=>[:fresh_install?]
  before_filter :check_logged_in, :except=>[:fresh_install?, :check_logged_in, :login]
  before_filter :determine_current_blog, :except=>[:fresh_install?, :check_logged_in, :login]
  before_filter :setup
  helper :admin
  layout 'admin'
  
  helper :sparklines
  
  def setup
    @current_user = current_user  
  end
  
  def determine_current_blog
    @current_blog = (Blog.find(session[:current_blog]) if session[:current_blog])|| Blog.find_by_domain(request.host_with_port) || Blog.find(:first)
    redirect_to(:controller=>'admin/blog', :action=>'new') unless (@current_blog || fresh_install?)
  end
  
  def clear_current_blog
    session[:current_blog] = @current_blog = nil
    
  end
  
  def current_blog=(blog_id)
    session[:current_blog] = blog_id

  end
  
  def switch
    session[:current_blog] = params[:id]
    redirect_to request.referer
  end
  
  def current_user
    Editor.find(logged_in?) if logged_in?
  end

  def logged_in?
    @logged_in ||= session[:user]
  end
  
  def check_logged_in
    unless logged_in?
      session[:was_going_to] = request.request_uri
      flash[:notice]= "Please log in"
      redirect_to(login_url) and return false
    end
  end
  
  def force_login editor
    session[:user] = editor.id if editor.kind_of? Editor
  end
  
  def login  
    if !session[:user]
      if request.get?
        @author = Author.new        
      elsif request.post?
        @user = Editor.authenticate(params[:user][:name], params["pwd"])
        if @user
          session[:user] = @user.id
          if session[:was_going_to]
            goto = session[:was_going_to]
            session[:was_going_to] = nil
            redirect_to goto
          else
            redirect_to :action=>"console"
          end 

        else
          flash[:login_error] = "Incorrect username and/or password."
        end
      end           
    else
      redirect_to :action=>"console" 
    end
  end

  def logout
    session[:user] = nil
    redirect_to :action=>"login"
  end
 
  def console
    @latest_posts = current_blog.posts.find(:all, :limit=>5) if current_user.blogs.member?(current_blog)
    @latest_commenters = current_blog.authors.find(:all, :select=>"distinct authors.*", :limit=>5, :order=>'created_at desc')  if current_user.blogs.member?(current_blog)
    @blogs = current_user.blogs.find(:all)
    @current_blog = current_blog
    
        

  end

  def fresh_install?
    (redirect_to(:controller=>'admin/setup') and return false) if Blog.count == 0 || Editor.count == 0
  end
  
  
end
