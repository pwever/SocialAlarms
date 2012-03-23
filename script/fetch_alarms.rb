#!/usr/bin/env ruby
require 'rubygems'
require 'hpricot'
require 'net/http'
require 'json'
require 'erb'

#service request stuff
def apirequest(service, command, opts={}, type=:get)
  # Open an HTTP connection to service
  serv = Net::HTTP.start(service)
  # proxy_addr = 'dawebproxy00.americas.nokia.com'
  # proxy_port = 8080
  # serv = Net::HTTP::Proxy(proxy_addr, proxy_port).start(service)
  
  # Depending on the request type, create either
  # an HTTP::Get or HTTP::Post object.. we only ever creat Get object
  case type
  when :get
    # Append the options to the URL
    command << "?" + opts.map{|k,v| "#{k}=#{v}" }.join('&')
    req = Net::HTTP::Get.new(command)
  end

  res = serv.request(req)

  # Raise an exception unless service
  # returned an OK result
  unless res.is_a? Net::HTTPOK
    #doc = Hpricot(res.body)
    #raise "#{(doc/'request').inner_html}: #{(doc/'error').inner_html}"
	raise "error in APIREQUEST: #{service}/#{command} not HTTPOK"
  end

  # Return the request body
  #return Hpricot(res.body) #old
  ret = res.body
  #p "%s" % ret #debug
  # logger.info "api call returned: %s" % ret
  return ret
end

def get_twitter(lat, long, sid)
	#latitude='40.757929'
	#longitude='-73.985506'
	radius='15mi'
	gc = lat.to_s+','+long.to_s+','+radius #40.757929,-73.985506,15mi

	#this doesn't give us "total"
	#d = apirequest('search.twitter.com', '/search.json', {'geocode'=>gc, 'since_id'=>sid.to_s, 'refresh'=>'true', 'rpp'=>'5'}) 
	
	begin
	#gives us json, and "total"
	d = apirequest('search.twitter.com', '/search', {'geocode'=>gc, 'since_id'=>sid.to_s, 'refresh'=>'true', 'rpp'=>'5'}) 
	rescue  Exception => exc
		Rails.logger.error("ERROR making apirequest for twitter: #{exc.message}")
		#flash[:notice] = "Store error message"
		return 0
	end
	
	#gives us json, and "total", and we can use 'near/within' !!!
	#d = apirequest('search.twitter.com', '/search', {'near'=>'90026', 'within'=>'15mi', 'since_id'=>sid.to_s, 'refresh'=>'true', 'rpp'=>'5'}) 

	#p d
	doc = JSON.parse(d)
	#p doc["warning"]
	#p doc["results"][0]
	lastid = doc["results"][0]["id"]
	p lastid
	 
	count = doc["total"]
	p count
	return count.to_i, lastid.to_i
	
end

def get_twitter_near(loc, rad, radu, sid)
	
	
	begin
	#gives us json, and "total"
	d = apirequest('search.twitter.com', '/search', {'near'=>ERB::Util.url_encode(loc), 'within'=>rad.to_s, 'units'=>radu, 'since_id'=>sid.to_s, 'refresh'=>'true', 'rpp'=>'5'}) 
	rescue  Exception => exc
		Rails.logger.error("ERROR making apirequest for twitter(near): #{exc.message}")
		#flash[:notice] = "Store error message"
		return 0
	end
	
	#gives us json, and "total", and we can use 'near/within' !!!
	#d = apirequest('search.twitter.com', '/search', {'near'=>'90026', 'within'=>'15mi', 'since_id'=>sid.to_s, 'refresh'=>'true', 'rpp'=>'5'}) 

  begin
  	# p d
  	doc = JSON.parse(d)
  	#p doc["warning"]
  	#p doc["results"][0]
  	lastid = doc["results"][0]["id"]
  	# p lastid
	 
  	count = doc["total"]
  	# p count
  	return count.to_i, lastid.to_i
	rescue
	  return 0, sid
  end
	
end

def get_traffic(road, ramp) 
  Rails.logger.error("Looking for traffic on %s at %s." % [road, Time.now.strftime("%Y-%m-%dT%H-%M")])
  
  begin
    doc = apirequest('old.sigalert.com', '/speeds.asp', {'Region' => ERB::Util.url_encode('Greater Los Angeles'), 'Road' => ERB::Util.url_encode(road)})
  rescue  Exception => exc
    p "ERROR making apirequest for traffic: #{exc.message}"
    Rails.logger.error("ERROR making apirequest for traffic: #{exc.message}")
    return 0
  end
  
	#scrape sigalert for the javascript commands to draw speeds.
	startindex = doc.index('DrawSpeed')
	# p "startindex: #{startindex.to_s()}"
	#regex matches javascript commands
	r = /DrawSpeed\(([0-9]*)(,'[a-z]*'),['a-z]*,[-0-9']*,['a-z]*,'([a-z 0-9 \/\(\).]*)',[0-9]\);/i
	curspeed = 0 #set it low so if in doubt, no trigger
	doc.scan(r) do |speed, extra, whichramp| 
		# p "speed: #{speed}  whichroad: #{whichramp}" 
		if (whichramp == ramp) then
			curspeed = speed.to_i
		end
	end
	Rails.logger.error("Traffic speed: %s." % curspeed)
	return curspeed
end

def get_surf(lval)
  begin
    res = apirequest('www.spitcast.com', '/3/api.php', {'lval'=>lval.to_s, 'dcat'=>'day' })
  rescue  Exception => exc
    Rails.logger.error("ERROR making apirequest for surf: #{exc.message}")
    p "ERROR making apirequest for surf: #{exc.message}"
    return 0
  end
  
  #get current hour string, to search against from spitcast 
  t = Time.now
  tmark = t.hour.to_s
  if (t.hour > 0) then
    if (t.hour > 12) then
      tmark = "#{t.hour-12}PM"
    elsif (t.hour < 12) then
      tmark = "#{t.hour}AM"
    else #hour is 12
      tmark="12PM"
    end
    
  else #hour is 0
    tmark = "12AM"
  end
  
  height = 0
  doc = Hpricot.XML(res)
  doc.search('SPOT//FORECAST').each do |f|
    hr = (f/'HOUR').inner_html
    wv = (f/'SIZE').inner_html
    # debug
    # p "#{wv}ft at #{hr}"
    # find waveheight for this hour
    if (hr==tmark) then 
      height=wv.to_i
    end
  end
  
  return height
end




# Fetch all active devices
Device.find(:all, :conditions => [ "enabled=?", true ]).each do |device|
  p "Check device %s" % device.email
  
  if (device.surf_alarm && device.surf_alarm.enabled && device.surf_alarm.start_time < Time.now)
    alarm = device.surf_alarm
    alert_condition = false
    
    if (alarm.beach) then
      cursurf = get_surf(alarm.beach.spitcast_id)
      p "Trigger above %ift. '%s' waves currently are %ift." % [alarm.wave_height, alarm.beach.name, cursurf]
      if (cursurf>=alarm.wave_height) then
        alert_condition=true
      end
    else
      p "No beach specified for surf_alarm %i." % alarm.id
    end

    if (alert_condition && device.email) then
      MailInterface.deliver_email(alarm.device.email, "", "surf %ift" % cursurf)
      alarm.advanceStartDate
    end
  end
  
  if (device.traffic_alarm && device.traffic_alarm.enabled && device.traffic_alarm.start_time < Time.now)
    alarm = device.traffic_alarm
    alert_condition = false

    curspeed = 0
    if (!alarm.road.nil? && !alarm.ramp.nil?) then
      curspeed = get_traffic(alarm.road.name, alarm.ramp.name)
      p "Triger above %imph. Current speed at '%s' is %imph." % [alarm.speed, alarm.ramp.name, curspeed]
      if (curspeed >= alarm.speed) then
        alert_condition = true
      end
    end

    if (alert_condition && device.email) then
      MailInterface.deliver_email(alarm.device.email, "", "traffic %imph" % curspeed)
      alarm.advanceStartDate
    end
  end
  
  if (device.twitter_alarm && device.twitter_alarm.enabled && device.twitter_alarm.start_time < Time.now)
    alarm = device.twitter_alarm
    alert_condition = false
    
    sid = 0
    if (!alarm.since_id.blank?) then
      sid = alarm.since_id
    end
    
    #count, lastid = get_twitter(alarm.lat, alarm.lng, sid) #using geocode
    #using twitter 'near'
    count, lastid = get_twitter_near(alarm.location, alarm.radius, alarm.radius_units, sid) 
    mins = (Time.now-alarm.updated_at) / 1.minute
    
    
    #update alarm since_id
    alarm.since_id = lastid
    alarm.save
    
    p "'%s': Target %itpm. %i in %fmins => %itpm." % [alarm.location, alarm.volume, count, mins, count/mins]
    #check if we are over threshold, and that this isn't the first time we're checking twitter
    if (count >= alarm.volume && sid>0) then
      alert_condition = true
    end
    
    if (alert_condition && device.email) then
      MailInterface.deliver_email(alarm.device.email, "", "twitter %itpm" % count)
      #reset since_id to 0 so we can refresh totals tomorrow
      alarm.since_id = 0
      alarm.save
      alarm.advanceStartDate
    end
  end
end





