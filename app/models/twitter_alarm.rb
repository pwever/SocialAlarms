class TwitterAlarm < ActiveRecord::Base
  
  belongs_to :device
  
  def advanceStartDate
    while (self.start_time < Time.now) do
      self.start_time += 1.day
    end
    self.save
  end
  
end
