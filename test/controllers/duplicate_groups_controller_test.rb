require 'test_helper'

class DuplicateGroupsControllerTest < ActionController::TestCase
  setup do
    @duplicate_group = duplicate_groups(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:duplicate_groups)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create duplicate_group" do
    assert_difference('DuplicateGroup.count') do
      post :create, duplicate_group: {  }
    end

    assert_redirected_to duplicate_group_path(assigns(:duplicate_group))
  end

  test "should show duplicate_group" do
    get :show, id: @duplicate_group
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @duplicate_group
    assert_response :success
  end

  test "should update duplicate_group" do
    patch :update, id: @duplicate_group, duplicate_group: {  }
    assert_redirected_to duplicate_group_path(assigns(:duplicate_group))
  end

  test "should destroy duplicate_group" do
    assert_difference('DuplicateGroup.count', -1) do
      delete :destroy, id: @duplicate_group
    end

    assert_redirected_to duplicate_groups_path
  end
end
