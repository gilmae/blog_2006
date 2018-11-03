require File.dirname(__FILE__) + '/../test_helper'

class NodeTest < Test::Unit::TestCase
  fixtures :nodes, :blogs, :authors, :thread_branches

  # Replace this with your real tests.
  def test_truth
    assert nodes(:draft_1)
  end
  
  def test_comment
    n = Node.new
    n.title='Thread test'
    n.body = 'Testing the commenting'
    n.author_id = 2
    n.publish
    n.parent = nodes(:reply_1)
    n.blog_id = 1
    n.save    
    
    assert n.errors.empty?
  end
  
  def test_published
    assert nodes(:recent_post).published?
    assert !nodes(:draft_1).published?
    assert nodes(:very_old_post).published?
    assert nodes(:closed_post).published?
  end
  
  def test_comment_closing
    assert !nodes(:draft_1).allow_followup?
    assert !nodes(:very_old_post).allow_followup?
    assert nodes(:recent_post).allow_followup?    
    assert !nodes(:closed_post).allow_followup? 
  end
  
  def test_children
    assert nodes(:recent_post).children.empty?
    assert !nodes(:very_old_post).children.empty?
  end
  
  def test_threading
    assert_not_equal nodes(:very_old_post).children.length, nodes(:very_old_post).descendants.length
    assert_equal nodes(:very_old_post).children.length, 1
    assert_equal nodes(:very_old_post).descendants.length, 2
  end
  
  def test_thread_weaving_new_thread_branch
    thread_branch_count = ThreadBranch.count
    assert_equal nodes(:very_old_post).descendants.length, 2
    
    n = Node.new
    n.title='Thread test'
    n.body = 'Testing the thread weaving, new thread_branch'
    n.author_id = 2
    n.published_at = Time.now
    n.parent = nodes(:reply_1_1)
    n.blog_id = 1
    assert n.save    
    
    assert_equal nodes(:very_old_post).descendants(true).length, 3
    assert_equal thread_branch_count+3, ThreadBranch.count
  end
  
  def test_tag_with
    n = Node.new
    n.title='Tag test'
    n.body = 'Testing the tagging'
    n.author_id = 2
    n.blog_id = 1
    n.tag_with 'one two'
    n.save    
    
    assert_equal 2, n.tags.length
 
    t2 = Tag.find_by_name('two')
    assert t2

    assert n.tags.member?(t2)

    n.tag_with 'one three'
    n.save    
    assert_equal 2, n.tags.length
    assert !n.tags.member?(t2)
  end
  
  def test_permalink_generation
    n = Node.new
    n.title='Permalink'
    n.body = 'Testing the permalink generation'
    n.author_id = 2
    n.blog_id = 1
    n.publish
    n.generate_permalink
 
    assert n.permalink
    assert_equal Time.now.strftime("%Y/%m/%d/Permalink"), n.permalink 
  end

  def test_duped_permalink_generation
    n = Node.new
    n.title='Permalink'
    n.body = 'Testing the permalink generation'
    n.author_id = 2
    n.blog_id = 1
    n.publish
    n.save

    n2 = Node.new
    n2.title='Permalink'
    n2.body = 'Testing the permalink generation'
    n2.author_id = 2
    n2.blog_id = 1
    n2.publish
    n2.generate_permalink

    assert_not_equal Time.now.strftime("%Y/%m/%d/Permalink"), n2.permalink 
  end

  def test_duped_permalink_generation_with_saving_crossover
    n = Node.new
    n.title='Permalink'
    n.body = 'Testing the permalink generation'
    n.author_id = 2
    n.blog_id = 1
    n.publish

    n2 = Node.new
    n2.title='Permalink'
    n2.body = 'Testing the permalink generation'
    n2.author_id = 2
    n2.blog_id = 1
    n2.publish
    n2.generate_permalink
    
    assert_equal Time.now.strftime("%Y/%m/%d/Permalink"), n2.permalink 
    
    n.save
    n2.save
    assert_not_equal Time.now.strftime("%Y/%m/%d/Permalink"), n2.permalink 
    
  end
  
  def test_find_published
    assert_equal 3, Node.published_posts.length
    
    assert !Node.published_posts.member?(nodes(:reply_1))
  end
  
  def test_close_comments
    assert !nodes(:reply_1).comments_closed
    
    nodes(:very_old_post).close_comments
    
    assert nodes(:very_old_post).comments_closed

    #assert nodes(:reply_1).comments_closed
    #assert nodes(:reply_1_1).comments_closed
  end
  
  def test_publish_now
    n2 = Node.new
    n2.title='Publish'
    n2.body = 'Testing the publish! method'
    n2.author_id = 2
    n2.blog_id = 1
    n2.publish!
    
    assert n2.id
    assert n2.published?
  end

end
