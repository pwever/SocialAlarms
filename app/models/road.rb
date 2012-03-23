
class Road < ActiveRecord::Base
  
  has_and_belongs_to_many :ramps
  
end
