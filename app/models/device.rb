class Device < ActiveRecord::Base
  
  validates_presence_of :imei, :email
  belongs_to :user
  has_one :surf_alarm
  has_one :traffic_alarm
  has_one :twitter_alarm
  
  def create_new_alarms
    # purges any alarms associated with this device,
    # and creates a new set
    
    surf_alarm.destroy    if surf_alarm
    traffic_alarm.destroy if traffic_alarm
    twitter_alarm.destroy if twitter_alarm
    
    surf_alarm    = SurfAlarm.new(   :device_id => self.id).save
    traffic_alarm = TrafficAlarm.new(:device_id => self.id).save
    twitter_alarm = TwitterAlarm.new(:device_id => self.id).save
    
  end
  
end
