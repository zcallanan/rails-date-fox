require 'test_helper'

class ActivitiesControllerTest < ActionDispatch::IntegrationTest
  test "should get edit" do
    get activities_edit_url
    assert_response :success
  end

end
