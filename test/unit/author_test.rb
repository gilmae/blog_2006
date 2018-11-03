require File.dirname(__FILE__) + '/../test_helper'
class AuthorTest < Test::Unit::TestCase
  fixtures :nodes, :authors
  
  def test_prune_nodes
    assert !authors(:gilmae).nodes.empty?
    authors(:gilmae).prune_nodes
    assert authors(:gilmae).nodes.empty?
  end
end