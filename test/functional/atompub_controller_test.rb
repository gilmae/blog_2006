require File.dirname(__FILE__) + '/../test_helper'
require 'atompub_controller'

# Re-raise errors caught by the controller.
class AtompubController; def rescue_action(e) raise e end; end

class AtompubControllerTest < Test::Unit::TestCase
  def setup
    @controller = AtompubController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
