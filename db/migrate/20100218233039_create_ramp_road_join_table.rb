class CreateRampRoadJoinTable < ActiveRecord::Migration
  def self.up
      create_table :ramps_roads, :id => false do |t|
	  t.integer :ramp_id
	  t.integer :road_id
      end
      ra = Ramp.new({:name => "Sunset"})
      ra.roads << Road.all
      ra.save
      ra = Ramp.new({:name => "Santa Monica"})
      ra.roads << Road.all
      ra.save
  end

  def self.down
	drop_table :ramps_roads
  end
end
