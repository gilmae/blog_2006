#---
# Excerpted from "Rails Recipes"
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/fr_rr for more book information.
#---
module ActionView
  module Helpers
    module TextHelper
      ALLOWED_TAGS = %w(a img strong em b i u strike) unless defined?(ALLOWED_TAGS)

      def whitelist(html)
        # only do this if absolutely necessary
        if html.index("<")
          tokenizer = HTML::Tokenizer.new(html)
          new_text = "" 

          while token = tokenizer.next
            node = HTML::Node.parse(nil, 0, 0, token, false)
            
            new_text << if node.kind_of?(HTML::Tag) && ALLOWED_TAGS.include?(node.name)
                            node.to_s
                        else
                          node.to_s.gsub(/</, "&lt;")
                        end
          end

          html = new_text
        end
        html
      end
    end
  end
end        