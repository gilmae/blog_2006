module Template::BlogHelper
   def blog_name
     @context.blog.name
   end
   
   def blog_subtitle
     @context.blog.sub_title
   end
   
   def blog_administrator
     @context.blog.editors[0].name
   end
   
   def blog_administrator_email
     @context.blog.editors[0].email
   end
   
   def blog_base_path
     "http://#{@context.blog.domain}"
   end
end