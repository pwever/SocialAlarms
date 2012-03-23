class AddSinceIdToTwitterAlarms < ActiveRecord::Migration
  def self.up
      add_column :twitter_alarms, :since_id, :integer
  end

  def self.down
      remove_column :twitter_alarms, :since_id
  end
end
