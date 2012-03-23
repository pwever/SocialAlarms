

xml.instruct!
xml.beaches do
  SurfAlarmBeaches.all.each do |beach|
    xml.beach(:id => beach.spitcast_id, :name => beach.name)
  end
end

