require 'test_helper'

class CustomerPointsControllerTest < ActionController::TestCase
  setup do
    @customer_point = customer_points(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:customer_points)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create customer_point" do
    assert_difference('CustomerPoint.count') do
      post :create, customer_point: { customer_id: @customer_point.customer_id, point: @customer_point.point }
    end

    assert_redirected_to customer_point_path(assigns(:customer_point))
  end

  test "should show customer_point" do
    get :show, id: @customer_point
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @customer_point
    assert_response :success
  end

  test "should update customer_point" do
    patch :update, id: @customer_point, customer_point: { customer_id: @customer_point.customer_id, point: @customer_point.point }
    assert_redirected_to customer_point_path(assigns(:customer_point))
  end

  test "should destroy customer_point" do
    assert_difference('CustomerPoint.count', -1) do
      delete :destroy, id: @customer_point
    end

    assert_redirected_to customer_points_path
  end
end
