class NodeSweeper < ActionController::Caching::Sweeper
  observe Node, Post, Comment
  
  def after_save(record)
    nodes = record.ancestors
    expire_page :controller=>:blog, :action=>:index
    
    record.tags.each {|tag|
      expire_page :controller=>:blog, :action=>:tag_archive, :tag=>tag.name
      
    }
    nodes.each {|node|
      permalink_parts = node.permalink.split("/")
      expire_page :controller=>:blog, :action=>:individual_page, :year=>permalink_parts[0], :month=>permalink_parts[1], :day=>permalink_parts[2], :title=>permalink_parts[3]
      expire_page :controller=>:blog, :action=>:followup, :year=>permalink_parts[0], :month=>permalink_parts[1], :day=>permalink_parts[2], :title=>permalink_parts[3]

      expire_page :controller=>:blog, :action=>:archive_page, :year=>permalink_parts[0], :month=>permalink_parts[1], :day=>permalink_parts[2]
      expire_page :controller=>:blog, :action=>:archive_page, :year=>permalink_parts[0], :month=>permalink_parts[1]
      expire_page :controller=>:blog, :action=>:archive_page, :year=>permalink_parts[0]
    }
  end
end
