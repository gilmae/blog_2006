class Admin::AuthorController < Admin::BaseController
  before_filter :check_logged_in
  
  layout 'admin'
  
  def index
    @authors = Author.paginate(:page => params[:page], :order=>["created_at desc"])
  end

  def show
     if request.get?
       @author = Author.find(params[:id]) if Author.exists?(params[:id])
     end
   end

   def delete
     user = current_user
     deceased = Author.find(params["id"])
     if deceased && user && user.id != deceased.id
        if request.post?
          Author.destroy(params["id"])
          redirect_to :action=>"index"
        end
     end
     redirect_to :action=>:index
   end  
 end