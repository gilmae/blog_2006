class Delicious::LinkController < ActionController::Base
   uses_component_template_root
   
   def get_linklist
      @posts = []
      if ENV['RAILS_ENV'] != 'development'
         http = Net::HTTP.new('api.del.icio.us', 443)
         http.use_ssl = true

         http.start do |http|      
            request = Net::HTTP::Get.new('/v1/posts/recent')
            request.basic_auth 'avocadia', "there's no there, there"
            response = http.request(request)
              
            if response.status = 200
              xml = response.body
              @posts = REXML::Document.new(xml).root.get_elements('post')
            end  
         end
      end
   end
end
