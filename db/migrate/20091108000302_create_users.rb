class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :username, :null => false
      t.string :password, :null => false
      t.boolean :admin, :default => false

      t.timestamps
    end
    
    User.new({:username => "admin", :password => "admin", :admin => true}).save
    User.new({:username => "user", :password => "user"}).save
    
  end

  def self.down
    drop_table :users
  end
end
