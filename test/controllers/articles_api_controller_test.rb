require 'test_helper'

class ArticlesApiControllerTest < ActionController::TestCase
  test "should get get_all_articles" do
    get :get_all_articles
    assert_response :success
  end

  test "should get get_article" do
    get :get_article
    assert_response :success
  end

end
