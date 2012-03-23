class AddLongLatToTwitterAlarms < ActiveRecord::Migration
  def self.up
      add_column :twitter_alarms, :lat, :float
      add_column :twitter_alarms, :lng, :float
  end

  def self.down
      remove_column :twitter_alarms, :lat
      remove_column :twitter_alarms, :lng
  end
end
