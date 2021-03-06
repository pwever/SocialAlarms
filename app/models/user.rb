class User < ActiveRecord::Base
  
  validates_presence_of :username, :password
  validates_uniqueness_of :username
  has_many :devices
  
end
