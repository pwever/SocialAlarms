class CreateTwitterAlarms < ActiveRecord::Migration
  def self.up
    create_table :twitter_alarms do |t|
      # common among all alarms
      t.integer :device_id
      t.boolean :enabled, :default => false
      t.datetime :start_time, :default => Date.today + 7.hours
      # unique
      t.string :location, :default => "[location]"
      t.integer :volume, :null => false, :default => 100

      t.timestamps
    end
    d = Device.first
    s = TwitterAlarm.new
    s.device = d
    s.save
  end

  def self.down
    drop_table :twitter_alarms
  end
end
