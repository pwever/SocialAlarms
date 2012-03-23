

xml.instruct!
xml.roads do
  Road.all.each do |road|
    xml.road(:id => road.id, :name => road.name) do
      xml.ramps do
        road.ramps.each do |ramp|
          xml.ramp(:id => ramp.id, :name => ramp.name)
        end
      end
    end
  end
end