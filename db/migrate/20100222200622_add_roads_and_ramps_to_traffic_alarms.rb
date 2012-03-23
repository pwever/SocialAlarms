class AddRoadsAndRampsToTrafficAlarms < ActiveRecord::Migration
  def self.up
    add_column :traffic_alarms, :road_id, :integer
    add_column :traffic_alarms, :ramp_id, :integer
    remove_column :traffic_alarms, :freeway
    remove_column :traffic_alarms, :ramp
    TrafficAlarm.all.each do |alarm|
	r = Road.first
	alarm.road = r
	alarm.ramp = r.ramps[0]
	alarm.save
    end
  end

  def self.down
    remove_column :traffic_alarms, :road_id
    remove_column :traffic_alarms, :ramp_id
    add_column :traffic_alarms, :freeway, :string
    add_column :traffic_alarms, :ramp, :string
  end
end
