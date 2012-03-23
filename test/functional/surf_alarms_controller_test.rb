require 'test_helper'

class SurfAlarmsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:surf_alarms)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create surf_alarm" do
    assert_difference('SurfAlarm.count') do
      post :create, :surf_alarm => { }
    end

    assert_redirected_to surf_alarm_path(assigns(:surf_alarm))
  end

  test "should show surf_alarm" do
    get :show, :id => surf_alarms(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => surf_alarms(:one).to_param
    assert_response :success
  end

  test "should update surf_alarm" do
    put :update, :id => surf_alarms(:one).to_param, :surf_alarm => { }
    assert_redirected_to surf_alarm_path(assigns(:surf_alarm))
  end

  test "should destroy surf_alarm" do
    assert_difference('SurfAlarm.count', -1) do
      delete :destroy, :id => surf_alarms(:one).to_param
    end

    assert_redirected_to surf_alarms_path
  end
end
