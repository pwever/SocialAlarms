class CreateDevices < ActiveRecord::Migration
  def self.up
    create_table :devices do |t|
      t.integer :user_id, :null => true
      t.string :imei, :null => false
      t.string :email, :null => false
      t.boolean :enabled, :default => false

      t.timestamps
    end
    
    u = User.first
    d = Device.new({:imei => "8184413424", :email => "8184413424@txt.att.net"})
    d.user = u
    d.save
  end

  def self.down
    drop_table :devices
  end
end
