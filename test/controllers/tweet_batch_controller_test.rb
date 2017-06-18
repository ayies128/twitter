require 'test_helper'

class TweetControllerTest < ActionDispatch::IntegrationTest
  test "should get afiri" do
    get tweet_afiri_url
    assert_response :success
  end

  test "should get everyday" do
    get tweet_everyday_url
    assert_response :success
  end

end
