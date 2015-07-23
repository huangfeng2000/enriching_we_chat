require 'test_helper'

class PointExchangesControllerTest < ActionController::TestCase
  setup do
    @point_exchange = point_exchanges(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:point_exchanges)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create point_exchange" do
    assert_difference('PointExchange.count') do
      post :create, point_exchange: { coupon_id: @point_exchange.coupon_id, customer_id: @point_exchange.customer_id, point: @point_exchange.point }
    end

    assert_redirected_to point_exchange_path(assigns(:point_exchange))
  end

  test "should show point_exchange" do
    get :show, id: @point_exchange
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @point_exchange
    assert_response :success
  end

  test "should update point_exchange" do
    patch :update, id: @point_exchange, point_exchange: { coupon_id: @point_exchange.coupon_id, customer_id: @point_exchange.customer_id, point: @point_exchange.point }
    assert_redirected_to point_exchange_path(assigns(:point_exchange))
  end

  test "should destroy point_exchange" do
    assert_difference('PointExchange.count', -1) do
      delete :destroy, id: @point_exchange
    end

    assert_redirected_to point_exchanges_path
  end
end
