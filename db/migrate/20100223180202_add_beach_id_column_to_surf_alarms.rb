class AddBeachIdColumnToSurfAlarms < ActiveRecord::Migration
  def self.up
    add_column :surf_alarms, :beach_id, :integer
    remove_column :surf_alarms, :location
    SurfAlarm.all.each do |alarm|
	alarm.beach = SurfAlarmBeaches.first
	alarm.save
    end
  end

  def self.down
    add_column :surf_alarms, :location, :string
    remove_column :surf_alarms, :beach_id
  end
end
