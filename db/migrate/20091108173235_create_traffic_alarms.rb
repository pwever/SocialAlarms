class CreateTrafficAlarms < ActiveRecord::Migration
  def self.up
    create_table :traffic_alarms do |t|
      # common among all alarms
      t.integer :device_id
      t.boolean :enabled, :default => false
      t.datetime :start_time, :default => Date.today + 7.hours
      # unique
      t.string :freeway, :default => "[freeway]"
      t.string :ramp, :default => "[ramp]"
      t.integer :speed, :default => 55

      t.timestamps
    end
    d = Device.first
    s = TrafficAlarm.new
    s.device = d
    s.save
  end

  def self.down
    drop_table :traffic_alarms
  end
end
