require 'test_helper'

class CommonControllerTest < ActionController::TestCase
  test "should get sshkeygen" do
    get :sshkeygen
    assert_response :success
  end

end
