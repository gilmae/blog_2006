module Template::NodeHelper
  def nodes options = nil, &block
     @context.node_stack = []
     @nodes_block = block
     
     if options
       @context.limit = options[:num] if options[:num]
       @context.allow_spam = options[:allow_spam] if options[:allow_spam]
     end
     
     @context.get_nodes
     @context.nodes.each { |node|
       @context.node_stack.push node
       @nodes_block.call
       @context.node_stack.pop
     }
     @context.thread = nil
  end
   
   def node_title
     @context.cur_node.title if @context.cur_node
   end
   
   def node_body
     textilize(@context.cur_node.body) if @context.cur_node
   end
   
   def node_excerpt
     (@context.cur_node.precis==""?textilize(sanitize(@context.cur_node.body)):@context.cur_node.precis) if @context.cur_node
   end
   
   def node_updated_at format="%d/%m/%Y"
     @context.cur_node.updated_at.utc.strftime(format)
   end
   
   def node_permalink
     "/#{@context.cur_node.permalink}" if @context.cur_node
   end
   
   def node_tag
     "/#{@context.cur_node.tag_uri}" if @context.cur_node
   end
   
   def node_author
     @context.cur_node.author.name if @context.cur_node && @context.cur_node.author
   end

   def node_author_email
     @context.cur_node.author.email if @context.cur_node && @context.cur_node.author
   end
   
   def node_date_published format=nil
     return @context.cur_node.published_at.strftime("%d/%m/%Y") unless format
     @context.cur_node.published_at.strftime(format)
     
   end
   
   def node_parent_permalink
     return "/#{@context.cur_node.parent.permalink}" if @context.cur_node && @context.cur_node.parent
     return ""
   end
   
   def node_parent_tag
     return "/#{@context.cur_node.parent.tag_uri}" if @context.cur_node && @context.cur_node.parent
     return ""
   end
   
   def node_date_as_archives_links
     link_to_date_archives(@context.cur_node) if @context.cur_node
   end
   
   def node_followup_link
     ("/#{@context.cur_node.permalink}/followup") if @context.cur_node
   end
   
   def node_descendant_count
     @context.cur_node.descendant_count.to_s if @context.cur_node
   end
   
   def if_node_allows_comment?
     if @context.cur_node.allow_followup?
       yield
     end
     ""
   end
   
   def child_nodes
     @context.thread ||= @context.cur_node.find_thread
     
     (@context.thread[@context.cur_node.id] || []).each do |node|
       @context.node_stack.push node
       @nodes_block.call
       @context.node_stack.pop
     end
   end
 
   def node_tags
     @context.cur_node.tags.each do |@tag|
       yield
     end
   end
   
   def tag_name
     @tag.name
   end
   
   def node_tag_count
     @context.cur_node.tags.length
   end
   
   def if_more_pages?
     if @context.more_pages?
       yield
     end
   end
   
   def if_fewer_pages?
     if @context.cur_page != 1
       yield
     end
   end
   
   def more_pages
     lnks = []
     max = @context.max_page
     max = @context.cur_page+10 if @context.cur_page+10 < max
     
     (@context.cur_page+1..max).each {|pp| lnks << link_to(pp.to_s, "http://" + request.host_with_port  + request.path + "?page=" + pp.to_s)}
     
     lnks << link_to("&gt;",  "http://" + request.host_with_port  + request.path + "?page=" + (@context.cur_page).to_s)
     lnks << link_to("&gt;&gt;",  "http://" + request.host_with_port  + request.path + "?page=" + (@context.max_page).to_s)
     lnks.join("&nbsp;\n")
    end
    
       
   def less_pages
     lnks = []
     min = 1
     min = @context.cur_page-10 if @context.cur_page-10 > min

     lnks << link_to("&lt;&lt;",  "http://" + request.host_with_port  + request.path + "?page=0")
     lnks << link_to("&lt;",  "http://" + request.host_with_port  + request.path + "?page=" + (@context.page).to_s)
     
     (min .. @context.cur_page-1).each {|pp| lnks << link_to(pp.to_s, "http://" + request.host_with_port  + request.path + "?page=" + pp.to_s)}
     
     lnks.join("&nbsp;\n")
    end
end
