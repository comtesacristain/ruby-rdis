require 'test_helper'

class DuplicatesControllerTest < ActionController::TestCase
  setup do
    @duplicate = duplicates(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:duplicates)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create duplicate" do
    assert_difference('Duplicate.count') do
      post :create, duplicate: {  }
    end

    assert_redirected_to duplicate_path(assigns(:duplicate))
  end

  test "should show duplicate" do
    get :show, id: @duplicate
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @duplicate
    assert_response :success
  end

  test "should update duplicate" do
    patch :update, id: @duplicate, duplicate: {  }
    assert_redirected_to duplicate_path(assigns(:duplicate))
  end

  test "should destroy duplicate" do
    assert_difference('Duplicate.count', -1) do
      delete :destroy, id: @duplicate
    end

    assert_redirected_to duplicates_path
  end
end
