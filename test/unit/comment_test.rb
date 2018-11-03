require File.dirname(__FILE__) + '/../test_helper'

class CommentTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  def test_truth
    assert true
  end
  fixtures :nodes, :blogs, :authors, :thread_branches

    
  def test_akismet_failure
    n = Comment.new
    n.title = 'viagra'
    n.body = 'viagra-test-123'
    a = Author.new
    a.name = 'viagra-test-123'
    a.url = 'viagra.com'
    a.save
    
    n.author = a
    n.blog_id = 1
    n.publish
    
    assert n.save
    assert_equal n.content_status, :spam
    
  end
  
    def test_akismet_success
    n = Comment.new
    n.title = 'test'
    n.body = 'test'
    a = Author.new
    a.name = 'test'
    a.url = 'test'
    a.save
    
    n.author = a
    n.blog_id = 1
    n.publish
    
    assert n.save
    assert !n.content_status
    
  end
end
