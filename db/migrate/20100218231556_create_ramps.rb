class CreateRamps < ActiveRecord::Migration
  def self.up
    create_table :ramps do |t|
      t.string :name
      t.timestamps
    end
  end

  def self.down
    drop_table :ramps
  end
end
