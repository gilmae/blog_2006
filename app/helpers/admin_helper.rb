module AdminHelper
  def blog_name
    @blog.name
  end
  
  def if_logged_in &block
    if logged_in?
      block.call
    end
  end
  
  def current_blog_name
    return @current_blog.name
  end
  
  def hourly_activity blog
      ohash = blog.nodes.count(:id, :select=>"year(published_at)*1000000+month(published_at)*10000+day(published_at)*100+hour(published_at)",
       :group=>"year(published_at)*1000000+month(published_at)*10000+day(published_at)*100+hour(published_at)",
       :order=>"year(published_at)*1000000+month(published_at)*10000+day(published_at)*100+hour(published_at) desc",
       :limit=>28)
    nodes_per_day = ohash.inject({}) do |all, row| 
      all[row.first] = row.last
      all
    end
     spark_data = []
    (1..550).to_a.reverse.each do |interval|
        spark_data<<(nodes_per_day[interval.hours.ago.strftime("%Y%m%d%H")]||0)
    end
    spark_data
  end 

  def daily_activity blog
      ohash = blog.nodes.count(:id, :select=>"year(published_at)*10000+month(published_at)*100+day(published_at)",
       :group=>"year(published_at)*10000+month(published_at)*100+day(published_at)",
       :order=>"year(published_at)*10000+month(published_at)*100+day(published_at) desc",
       :limit=>28)
    nodes_per_day = ohash.inject({}) do |all, row| 
      all[row.first] = row.last
      all
    end
     spark_data = []
    (1..28).to_a.reverse.each do |interval|
        spark_data<<(nodes_per_day[interval.days.ago.strftime("%Y%m%d")]||0)
    end
    spark_data
  end
end
