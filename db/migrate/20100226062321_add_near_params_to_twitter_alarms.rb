class AddNearParamsToTwitterAlarms < ActiveRecord::Migration
  def self.up
    add_column :twitter_alarms, :radius, :decimal, :default => 2
    add_column :twitter_alarms, :radius_units, :string, :default => 'mi'
  end

  def self.down
    remove_column :twitter_alarms, :radius_units
    remove_column :twitter_alarms, :radius
  end
end
