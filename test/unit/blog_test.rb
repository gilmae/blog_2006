require File.dirname(__FILE__) + '/../test_helper'

class BlogTest < Test::Unit::TestCase
  fixtures :blogs, :nodes, :nodes_tags, :tags

  self.use_instantiated_fixtures  =  true

  # Replace this with your real tests.
  def test_exists
    assert @testcadia
  end
  
  def test_theme
    assert_equal 'avocadia', @testcadia.current_theme.name
  end
 
  def test_published_posts
    assert_not_equal @testcadia.nodes, @testcadia.published_posts
    assert @testcadia.nodes.member?(@draft_1)
    assert !@testcadia.posts.member?(@draft_1)
    assert @testcadia.posts.member?(@very_old_post)
    
    assert !@testcadia.posts.member?(@tomorrows_post)
  end
  
  def test_blog_tags
    t1 = Tag.find_by_name('tag_1')
    assert t1

    assert_not_equal 0, @testcadia.tags.length
    assert @testcadia.tags.member?(t1)
    
    tag = Tag.new
    tag.name = 'test_tag'
    assert !@testcadia.tags.member?(tag)
    
    @very_old_post.tags << tag
    tag.save
    
    assert @testcadia.tags.member?(tag)
  end
  
  def test_blog_domain_is_unique
    new_blog = Blog.new
    new_blog.name = 'New Blog'
    new_blog.sub_title = 'Testing the domain uniqueness constraint'
    new_blog.domain = @testcadia.domain
    
    assert !new_blog.save
    assert new_blog.errors[:domain]
    
    new_blog.domain = '666.666.666.666'
    assert new_blog.save
  end
end
