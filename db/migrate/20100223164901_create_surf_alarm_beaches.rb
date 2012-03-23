class CreateSurfAlarmBeaches < ActiveRecord::Migration
  def self.up
    create_table :surf_alarm_beaches do |t|
      t.integer :spitcast_id
      t.string :name
      t.timestamps
    end
    
    spitcast_spots = {
	    'County Line' => 207,
	    'Zuma Beach' => 206,
	    'Malibu' => 205,
	    'Topanga' => 388,
	    'Bay Street'  => 204,
	    'El Porto' => 402,
	    'Manhattan Beach' => 203,
	    'Torrance Beach' => 200
    }
    
    spitcast_spots.each do |k,v|
	SurfAlarmBeaches.create :name => k, :spitcast_id => v
    end 
  end

  def self.down
    drop_table :surf_alarm_beaches
  end
end
