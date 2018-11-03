module BlogHelper
   def link_to_date_archives(node)
     lnks = []
     if node.published?
        if /^(\d{4})\/(\d{2})\/(\d{2})(\/(.+))?/ =~ node.permalink
          lnks << link_to($3, "/#{$1}/#{$2}/#{$3}")
          lnks << link_to($2, "/#{$1}/#{$2}")
          lnks << link_to($1, "/#{$1}")
        end
     end
     return lnks.join("/")
   end

   def link_to_followup(node)
     html = ""
     if node.published_at && node.allow_followup
        html << link_to("followup", "/#{node.permalink}/followup")
     end
     return html
   end

   def link_to_author_archives(node)
     html = ""
     html << content_tag("cite", node.author.name, {"href"=>node.author.url})
     return html
   end

   def link_to_thread_feed node
     return link_to("watch thread", "/feed/#{node.permalink}")
   end

   def days_since_x
      days = (rand*365).to_i + 1
      _day = (Time.now - days*86400).utc
      html = link_to days.to_s, "/#{_day.strftime("%Y/%m/%d")}"
      html << " days since "
      html << link_to(_day.strftime("%d/%m/%Y"), "http://wikipedia.com/wiki/#{_day.strftime("%B_%d")}", {"onclick"=>"window.open(this.href);return false;"})
   end


end
