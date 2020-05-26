require 'test_helper'

class CitiesControllerTest < ActionDispatch::IntegrationTest
  test "should get edit" do
    get cities_edit_url
    assert_response :success
  end

end
