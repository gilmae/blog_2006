class Admin::EditorController < Admin::BaseController
  before_filter :check_logged_in

  layout 'admin'
  
  def index
    @editors = Editor.paginate(:page => params[:page], :order=>["created_at"])
  end
  
  def new
     a = Author.new
     if request.get?
        @editor = Editor.new
     elsif request.post?
        @editor = get_editor_from_params
                   
        redirect_to(:action=>:show, :id=>@editor.id) if @editor.save 
     end
  end

  def edit
    if request.get?
      if !Editor.exists?(params[:id])
        flash[:genral_error] = "Could not find editor."
        redirect_to(:action=>:new) 
      else
        @editor = Editor.find(params[:id])
      end
    elsif request.post? || request.put?
        @editor = get_editor_from_params

      redirect_to :action=>:show if @editor.save 
    end
  end 
  
  def delete
    if request.post? || request.delete?
      if !Editor.exists?(params[:id])
        flash[:genral_error] = "Could not find editor."
      else
        Editor.destroy(params[:id])
      end
    end
    redirect_to :action=>:index
  end
  
  def show
    @editor = Editor.find(params[:id])  
  end

  private
  def get_editor_from_params
    if params[:editor][:id] && Editor.exists?(params[:editor][:id])
      editor = Editor.find(params[:editor][:id])
      editor.attributes = params[:editor]
    else
      editor = Editor.new(params[:editor])
    end
    
    if params[:editor][:password] != ""
      editor.password = params[:editor][:password] ## Why do I need to do this step?!?
      editor.password_confirmation = params[:editor][:password_confirmation]
    end  
    return editor
  end  

end
