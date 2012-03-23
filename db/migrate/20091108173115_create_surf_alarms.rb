class CreateSurfAlarms < ActiveRecord::Migration
  def self.up
    create_table :surf_alarms do |t|
      # common among all alarms
      t.integer :device_id
      t.boolean :enabled, :default => false
      t.datetime :start_time, :default => Date.today + 7.hours
      # unique
      t.string :location, :default => "[location]"
      t.integer :wave_height, :default => 6

      t.timestamps
    end
    d = Device.first
    s = SurfAlarm.new
    s.device = d
    s.save
  end


  def self.down
    drop_table :surf_alarms
  end
end
