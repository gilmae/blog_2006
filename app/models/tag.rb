class Tag < ActiveRecord::Base
  has_and_belongs_to_many :nodes

  def self.parse(list)
    tag_names = []

    # first, pull out the quoted tags
    list.gsub!(/\"(.*?)\"\s*/ ) { tag_names << $1; "" }

    # then, replace all commas with a space
    list.gsub!(/,/, " ")

    # then, get whatever's left
    tag_names.concat list.split(/\s/)

    # strip whitespace from the names
    tag_names = tag_names.map { |t| t.strip }

    # delete any blank tag names
    tag_names = tag_names.delete_if { |t| t.empty? }
    
    return tag_names
  end

  def ==(comparison_object)
    super || name == comparison_object.to_s
  end
  
  def to_s
    name
  end

#  def merge to_merge 
#    tags = Tag.find(to_merge)
#    tags.each {|tag|
#      (tag.tagged - self.tagged).each { |item|
#        item.tag_with self.name
#        item.save
#      }
#      Tagging.delete_all "tag_id=#{tag.id}"
#      Tag.delete(tag.id)
#    }
#  end
end
