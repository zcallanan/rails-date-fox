require 'test_helper'

class DateTimesControllerTest < ActionDispatch::IntegrationTest
  test "should get edit" do
    get date_times_edit_url
    assert_response :success
  end

  test "should get update" do
    get date_times_update_url
    assert_response :success
  end

end
