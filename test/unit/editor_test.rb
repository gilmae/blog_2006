require File.dirname(__FILE__) + '/../test_helper'

class EditorTest < Test::Unit::TestCase
  fixtures :authors
  
  def test_truth
    assert authors(:gilmae)
  end
  
  def test_editor_type
    assert authors(:gilmae).kind_of?(Editor)
    assert !authors(:nemesisau).kind_of?(Editor)
  end
  
  def test_salt
    assert authors(:gilmae).salt
    assert_not_equal '', authors(:gilmae).salt
  end
  
  def test_authentication
    assert authors(:gilmae).authenticate('gilmae')
    assert_equal authors(:gilmae), Editor.authenticate('gilmae', 'gilmae')
    assert_not_equal authors(:gilmae), Editor.authenticate('gilmae', 'gilmae2')
  end
  
  def test_new_password
    editor = Editor.new
    editor.password = 'test'
    
    assert editor.salt
    assert editor.hashed_password
    assert editor.authenticate('test')
  end

end