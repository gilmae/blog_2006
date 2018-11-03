module Template::CommentHelper
   def comment_title
     @context.comment.title if @context.comment
   end
   
   def comment_body
    textilize(sanitize(@context.comment.body)) if @context.comment && @context.comment.body
   end
   
   def comment_permalink
     "/#{@context.comment.permalink}" if @context.comment
   end
   
   def comment_author
     @context.comment.author.name if @context.comment && @context.comment.author
   end
  
   def comment_tags
     @context.comment.tags.each do |@comment_tag|
       yield
     end
   end
   
   def comment_tag_name
     @comment_tag.name
   end
   
   def start_comment_form 
     comment_form = "<form method=\"post\">"
     comment_form << "\n<input type=\"hidden\" name=\"node[parent_id]\" value=\"#{@context.comment.parent_id}\" />"
     comment_form
   end 

   def end_comment_form  
     "</form>"
   end
   
   def comment_form_errors
     errors = "<ul>"
     
     @context.comment.errors.each {|field, message| errors << "<li>#{message}</li>"}
     @context.comment.author.errors.each {|field, message| errors << "<li>#{message}</li>"}
     
     errors << "</ul>"
     errors
   end
   
   def comment_form_post_button
     "<input type=\"submit\" value=\"post\" name=\"command\"/>"
   end
   
   def comment_form_preview_button
     "<input type=\"submit\" value=\"preview\" name=\"command\"/>"
   end

   def comment_form_title id="node_title"
      "<input type=\"text\" id=\"#{id}\" name=\"node[title]\" value=\"#{@context.comment.title}\" />"
   end

   def comment_form_body id="node_body"
      "<textarea id=\"#{id}\" name=\"node[body]\">#{@context.comment.body}</textarea>"
   end

   
   def comment_form_author_name id="author_name"
      "<input type=\"text\" id=\"#{id}\" name=\"author[name]\" value=\"#{@context.comment.author.name}\" />"
      
   end

   def comment_form_author_email id="author_email"
     "<input type=\"text\" id=\"#{id}\" name=\"author[email]\" value=\"#{@context.comment.author.email}\" />"
     
   end

   def comment_form_author_url id="author_url"
     "<input type=\"text\" id=\"#{id}\" name=\"author[url]\" value=\"#{@context.comment.author.url}\" />"
   end
      
   def comment_remember_me id="remember_me"
     "<input type=\"checkbox\" name=\"remember_me\" id=\"#{id}\" checked=\"#{(@remember_as_cookie)?"checked":""} />"
   end
end
