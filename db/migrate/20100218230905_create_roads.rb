class CreateRoads < ActiveRecord::Migration
  def self.up
    create_table :roads do |t|
      t.string :name
      t.timestamps
    end
    Road.new({:name => "101 North"}).save
    Road.new({:name => "101 South"}).save
  end

  def self.down
    drop_table :roads
  end
end
