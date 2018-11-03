class Admin::IpController < Admin::BaseController
  before_filter :check_logged_in
  before_filter :determine_current_blog, :except=>[:check_logged_in, :login, :new]

  layout 'admin'

  def show
    @ip = Ip.find(params[:id])
  end

  def index
    @ips = Ip.paginate(:page => params[:page], :order=>"updated_at desc")
  end
  
  
  def delete
    if request.post? || request.delete?
      Ip.destroy(params[:id])
      
    end
    
    redirect_to :action=>:index
  end
  
  def block_ip
    ip = Ip.find(params[:id])
    if ip
      ip.is_blacklisted = true
      ip.save
      redirect_to :action=>:show, :id=>ip.id
    else
       redirect_to :action=>:index
    end    
  end

  
  def unblock_ip
    ip = Ip.find(params[:id])
    if ip
      ip.is_blacklisted = false
      ip.save
      redirect_to :action=>:show, :id=>ip.id
    else
       redirect_to :action=>:index
    end    
  end
end
