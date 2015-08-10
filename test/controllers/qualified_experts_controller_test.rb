require 'test_helper'

class QualifiedExpertsControllerTest < ActionController::TestCase
  test "should get new" do
    get :new
    assert_response :success
  end

  test "should get create" do
    get :create
    assert_response :success
  end

  test "should get pay" do
    get :pay
    assert_response :success
  end

  test "should get get_all_available" do
    get :get_all_available
    assert_response :success
  end

end
