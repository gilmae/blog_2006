require File.dirname(__FILE__) + '/../test_helper'
require 'ips_controller'

# Re-raise errors caught by the controller.
class IpsController; def rescue_action(e) raise e end; end

class IpsControllerTest < Test::Unit::TestCase
  fixtures :ips

  def setup
    @controller = IpsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
