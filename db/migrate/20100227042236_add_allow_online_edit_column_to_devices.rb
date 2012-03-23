class AddAllowOnlineEditColumnToDevices < ActiveRecord::Migration
  def self.up
      add_column :devices, :allow_online_edit, :boolean, :default =>
      false
  end

  def self.down
      remove_column :devices, :allow_online_edit
  end
end
