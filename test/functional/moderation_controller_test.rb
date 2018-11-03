require File.dirname(__FILE__) + '/../test_helper'
require 'moderation_controller'

# Re-raise errors caught by the controller.
class ModerationController; def rescue_action(e) raise e end; end

class ModerationControllerTest < Test::Unit::TestCase
  def setup
    @controller = ModerationController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
