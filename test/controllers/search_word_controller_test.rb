require 'test_helper'

class SearchWordControllerTest < ActionDispatch::IntegrationTest
  test "should get list" do
    get search_word_list_url
    assert_response :success
  end

end
