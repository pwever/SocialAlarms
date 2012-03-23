class MailInterface < ActionMailer::Base
  
  def email(to, sub, bod, sent_at = Time.now)
    mail_settings = YAML.load(File.read(File.join(RAILS_ROOT, 'config', 'mail.yml')))
    subject    sub
    recipients to
    from       mail_settings['email_address']
    sent_on    sent_at
    
    body       bod
  end
  
  def receive(email)
    # Google Voice Number: (323) 206-6379
    
    p "******* Receiving email *******"
    # p "Subject: %s" % email['subject']
    # p "From: %s" % email['from']
    # p "To: %s" % email['to']
    # p "Date: %s" % email['date']
    p "Body: %s" % email.body
    
    # Find the sender
    # (Google voice include the senders phone number in the subject)
    phone_number_string = ""
    email['subject'].to_s.each_char do |cc|
      phone_number_string = phone_number_string + cc if "0123456789".include? cc
    end
    p "Sender's phone number is: %s" % phone_number_string
    # Find the device (based on phone number)
    device = Device.find(:first, :conditions => { :imei => phone_number_string })
    return false unless device && device.user
    Time.zone = device.user.time_zone
    
    return (find_matches(device, email.body)>0)
    
  end
  
  def find_matches(device, body)
    # extract the setting from the body
    patterns = []
    patterns.push(/(surf),\s?(\d),\s?([\d:]+),\s?(\d+),\s?(\d+)/i) # S60
    patterns.push(/(surf)\s(\d+)/i)
    patterns.push(/(traffic),\s?(\d),\s?([\d:]+),\s?(\d+),\s?(\d+),\s?(\d+)/i) # S60
    patterns.push(/(traffic)\s(\d+)/i)
    patterns.push(/(twitter),\s?(\d+),\s?([\d:]+),\s?['"]([^,]+)['"],\s?(\d+),\s?(\d+)/i) # S60
    # TODO: Make quotes optional in this regex
    patterns.push(/(twitter)\s(\d+)/i)
    
    found_matches = 0
    patterns.each do |pattern|
      matches = body.scan(pattern)
      unless matches.empty? then
        found_matches += 1
        matches.each do |match|
          case match[0].downcase
          when "surf"
            update_surf_alarm(device, match)
          when "traffic"
            update_traffic_alarm(device, match)
          when "twitter"
            update_twitter_alarm(device, match)
          else
            p "Don't know how to interpret '%s'." % match[0]
          end
        end
      end
    end
    
    return found_matches
  end
  
  def update_surf_alarm(device, match_data)
    return false unless alarm = device.surf_alarm
    md = match_data
    
    if (md.length==5) then
      # S60 update
      alarm.enabled = (md[1]=="1")
      alarm.start_time = Time.zone.parse(md[2])
      alarm.beach = SurfAlarmBeaches.find(md[3].to_i)
      alarm.wave_height = md[4].to_i
      
    elsif (md.length==2) then
      # clock update
      alarm.wave_height = md[-1].to_i
    end
    return alarm.save
  end
  
  def update_traffic_alarm(device, match_data)
    return false unless alarm = device.traffic_alarm
    
    md = match_data
    
    if (md.length==6) then
      # S60 update
      alarm.enabled = (md[1]=="1")
      alarm.start_time = Time.zone.parse(md[2])
      alarm.road = Road.find(md[3].to_i)
      alarm.ramp = Ramp.find(md[4].to_i)
      alarm.speed = md[5].to_i
      
    elsif (md.length==2) then
      # clock update
      alarm.speed = md[-1].to_i
    end
    return alarm.save
  end
  
  def update_twitter_alarm(device, match_data)
    return false unless alarm = device.twitter_alarm
    md = match_data
    
    if (md.length==6) then
      # S60 update
      alarm.enabled = (md[1]=="1")
      alarm.start_time = Time.zone.parse(md[2])
      alarm.location = md[3]
      alarm.volume = md[4].to_i
      alarm.radius = md[5].to_i
      
    elsif (md.length==2) then
      # clock update
      alarm.volume = md[-1].to_i
    end
    return alarm.save
  end

end


