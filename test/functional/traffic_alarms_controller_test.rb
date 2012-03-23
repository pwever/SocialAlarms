require 'test_helper'

class TrafficAlarmsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:traffic_alarms)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create traffic_alarm" do
    assert_difference('TrafficAlarm.count') do
      post :create, :traffic_alarm => { }
    end

    assert_redirected_to traffic_alarm_path(assigns(:traffic_alarm))
  end

  test "should show traffic_alarm" do
    get :show, :id => traffic_alarms(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => traffic_alarms(:one).to_param
    assert_response :success
  end

  test "should update traffic_alarm" do
    put :update, :id => traffic_alarms(:one).to_param, :traffic_alarm => { }
    assert_redirected_to traffic_alarm_path(assigns(:traffic_alarm))
  end

  test "should destroy traffic_alarm" do
    assert_difference('TrafficAlarm.count', -1) do
      delete :destroy, :id => traffic_alarms(:one).to_param
    end

    assert_redirected_to traffic_alarms_path
  end
end
