#!/usr/bin/env ruby
require 'rubygems'
require 'hpricot'
require 'net/http'
require 'json'
require 'erb'

###elise

#spitcast beach names <-> spitcast IDs
#these are all of the beaches for "Los Angeles" county.. we could add other spots since IDs do not overlap
spitcast_spots = {
'County Line' => 207,
'Zuma Beach' => 206,
'Malibu' => 205,
'Topanga' => 388,
'Bay Street'  => 204,
'El Porto' => 402,
'Manhattan Beach' => 203,
'Torrance Beach' => 200}



#service request stuff
def apirequest(service, command, opts={}, type=:get)
  # Open an HTTP connection to service
  serv = Net::HTTP.start(service)

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
  return ret
end


def get_ramps(road)
	begin
	doc = apirequest('old.sigalert.com', '/speeds.asp', {'Region'=>ERB::Util.url_encode('Greater Los Angeles'), 'Road'=>ERB::Util.url_encode(road)})
	#doc = apirequest('old.sigalert.com', '/speeds.asp', {'Region'=>ERB::Util.url_encode('Greater Los Angeles')})
	#doc = apirequest('old.sigalert.com', '/speeds.asp', {})
	rescue  Exception => exc
		Rails.logger.error("ERROR making apirequest for traffic: #{exc.message}")
		#flash[:notice] = "Store error message"
		return 0
	end
	
	#scrape sigalert for the javascript commands to draw speeds.
	ramps = Array.new
	#regex matches javascript commands
	r = /DrawSpeed\(([0-9]*)(,'[a-z]*'),['a-z]*,[-0-9']*,['a-z]*,'([a-z 0-9 \/\(\).]*)',[0-9]\);/i 
	curspeed=0 #set it low so if in doubt, no trigger
	doc.scan(r) do |speed, extra, whichramp| 
		#p "speed: #{speed}  whichroad: #{whichramp}" 
		ramps.push(whichramp.to_s())
	end
	return ramps

end

def get_roads() 
	begin
	doc = apirequest('old.sigalert.com', '/speeds.asp', {'Region'=>ERB::Util.url_encode('Greater Los Angeles'), 'Road'=>ERB::Util.url_encode('2 North')})
	rescue  Exception => exc
		Rails.logger.error("ERROR making apirequest for traffic: #{exc.message}")
		#flash[:notice] = "Store error message"
		return 0
	end
	
	roads = Array.new

	#regex matches javascript commands to scrape for all roads (freeways + direction)
	r = /javascript:ss\('([a-z 0-9 A-Z \/\(\).]*)'\)/i
	
	doc.scan(r) do |road| 
		p "road: #{road}" 
		roadname = road.to_s()
		roads.push(roadname)
		

	end
	
	p roads
	
	roads.each do |r|
		#p "ROAD: #{r}" 
		fr = Road.find(:first, :conditions => { :name => r })
		if (fr.nil?) then
			p "adding road #{r}"
			fr = Road.new(:name => r)
			fr.save
		end
		fr.ramps.clear
		rmps = get_ramps(r)
		rmps.each do |p|
		#	p "     #{p}"
			frmp = Ramp.find(:first, :conditions => { :name => p })
			if (frmp.nil?) then
				p "adding ramp #{p}"
				frmp = Ramp.new(:name => p)
				frmp.save
			else
				p "ramp #{p} exists"
			end
			#add association
			fr.ramps << frmp
		end
	end
	
	
	
end



#p "GETTING ROADS"
get_roads
dbroads = Road.find(:all)
	dbroads.each do |r|
		p "ROAD: #{r.name}" 
		r.ramps.each do |p|
			p "     #{p.name}"
	end
end
	

