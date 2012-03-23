# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100227042236) do

  create_table "devices", :force => true do |t|
    t.integer  "user_id"
    t.string   "imei",                                 :null => false
    t.string   "email",                                :null => false
    t.boolean  "enabled",           :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "allow_online_edit", :default => false
  end

  create_table "ramps", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ramps_roads", :id => false, :force => true do |t|
    t.integer "ramp_id"
    t.integer "road_id"
  end

  create_table "roads", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "surf_alarm_beaches", :force => true do |t|
    t.integer  "spitcast_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "surf_alarms", :force => true do |t|
    t.integer  "device_id"
    t.boolean  "enabled",     :default => false
    t.datetime "start_time",  :default => '2010-02-26 07:00:00'
    t.integer  "wave_height", :default => 6
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "beach_id"
  end

  create_table "traffic_alarms", :force => true do |t|
    t.integer  "device_id"
    t.boolean  "enabled",    :default => false
    t.datetime "start_time", :default => '2010-02-26 07:00:00'
    t.integer  "speed",      :default => 55
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "road_id"
    t.integer  "ramp_id"
  end

  create_table "twitter_alarms", :force => true do |t|
    t.integer  "device_id"
    t.boolean  "enabled",      :default => false
    t.datetime "start_time",   :default => '2010-02-26 07:00:00'
    t.string   "location",     :default => "[location]"
    t.integer  "volume",       :default => 100,                   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "since_id"
    t.float    "lat"
    t.float    "lng"
    t.decimal  "radius",       :default => 2.0
    t.string   "radius_units", :default => "mi"
  end

  create_table "users", :force => true do |t|
    t.string   "username",                                             :null => false
    t.string   "password",                                             :null => false
    t.boolean  "admin",      :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "time_zone",  :default => "Pacific Time (US & Canada)"
  end

end
