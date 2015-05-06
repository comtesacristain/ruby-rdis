require 'test_helper'

class BoreholesControllerTest < ActionController::TestCase
  setup do
    @borehole = boreholes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:boreholes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create borehole" do
    assert_difference('Borehole.count') do
      post :create, borehole: {  }
    end

    assert_redirected_to borehole_path(assigns(:borehole))
  end

  test "should show borehole" do
    get :show, id: @borehole
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @borehole
    assert_response :success
  end

  test "should update borehole" do
    patch :update, id: @borehole, borehole: {  }
    assert_redirected_to borehole_path(assigns(:borehole))
  end

  test "should destroy borehole" do
    assert_difference('Borehole.count', -1) do
      delete :destroy, id: @borehole
    end

    assert_redirected_to boreholes_path
  end
end
