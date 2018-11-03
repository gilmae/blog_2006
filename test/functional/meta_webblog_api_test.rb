require File.dirname(__FILE__) + '/../test_helper'
require 'meta_webblog_controller'

class MetaWebblogController; def rescue_action(e) raise e end; end

class MetaWebblogControllerApiTest < Test::Unit::TestCase
  def setup
    @controller = MetaWebblogController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end
end
