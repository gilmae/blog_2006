module Template::FeedHelper
  
   def feeds &block
     @context.feeds.each do |@feed|
       yield
     end
   end
   
   def feed_name
     @feed
   end
   
   def feed_url
     url_for(:controller=>'feed', :action=>@feed)
   end
   
   def feeds_main_feed name='main'
     link_to name, url_for(:controller=>'feed', :action=>'main')
   end
   
   def feeds_comments_feed name='comments'
     link_to name, url_for(:controller=>'feed', :action=>'comments')
   end
   
   def feeds_thread_feed name='thread'
     link_to name, url_for(:controller=>'feed', :action=>'thread')
   end
end