class Admin::ThemeController < ApplicationController
  @@theme_export_path = RAILS_ROOT + 'tmp/theme'
  @@theme_content_types = %w(application/zip multipart/x-zip application/x-zip-compressed)
  
  cattr_accessor :theme_export_path, :theme_content_types
  layout 'admin'
  
  def index
    @themes = Theme.find_all
  end

  def new
    return unless request.post?
    unless params[:theme] && params[:theme].size > 0 && theme_content_types.include?(params[:theme].content_type.strip)
      flash.now[:error] = "Invalid theme uploaded."
      return
    end
    filename = params[:theme].original_filename
    filename.gsub!(/(^.*(\\|\/))|(\.zip$)/, '')
    filename.gsub!(/[^\w\.\-]/, '_')
    begin
      theme_site_path = temp_theme_path_for(filename)
      zip_file        = theme_site_path + "temp.zip"
      File.open(zip_file, 'wb') { |f| f << params[:theme].read }
      site.import_theme zip_file, filename
      flash[:notice] = "The '#{filename}' theme has been imported."
      redirect_to :action => 'index'
    rescue
      flash.now[:error] = "Invalid theme uploaded: [#{$!.class.name}] #{$!}"
    ensure
      theme_site_path.rmtree
    end
  end
  
  def edit
  end

  def show
    @theme = Theme.find(params[:theme])
  end

  def delete
  end
  
  def temp_theme_path_for(prefix)
    returning theme_export_path + "site-#{current_blog.id}/#{prefix}#{Time.now.utc.to_i.to_s.split('').sort_by { rand }}" do |path|
      FileUtils.mkdir_p path unless path.exist?
    end
  end  
end
