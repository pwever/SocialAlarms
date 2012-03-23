require 'test_helper'

class TwitterAlarmsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:twitter_alarms)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create twitter_alarm" do
    assert_difference('TwitterAlarm.count') do
      post :create, :twitter_alarm => { }
    end

    assert_redirected_to twitter_alarm_path(assigns(:twitter_alarm))
  end

  test "should show twitter_alarm" do
    get :show, :id => twitter_alarms(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => twitter_alarms(:one).to_param
    assert_response :success
  end

  test "should update twitter_alarm" do
    put :update, :id => twitter_alarms(:one).to_param, :twitter_alarm => { }
    assert_redirected_to twitter_alarm_path(assigns(:twitter_alarm))
  end

  test "should destroy twitter_alarm" do
    assert_difference('TwitterAlarm.count', -1) do
      delete :destroy, :id => twitter_alarms(:one).to_param
    end

    assert_redirected_to twitter_alarms_path
  end
end
