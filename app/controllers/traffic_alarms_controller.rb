class TrafficAlarmsController < ApplicationController
  
  before_filter :admin_check, :except => [:edit, :update, :roads, :ramps, :ramp_options]
  
  # GET /traffic_alarms
  # GET /traffic_alarms.xml
  def index
    @traffic_alarms = TrafficAlarm.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @traffic_alarms }
    end
  end

  # GET /traffic_alarms/1
  # GET /traffic_alarms/1.xml
  def show
    @traffic_alarm = TrafficAlarm.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @traffic_alarm }
    end
  end

  # GET /traffic_alarms/new
  # GET /traffic_alarms/new.xml
  def new
    @traffic_alarm = TrafficAlarm.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @traffic_alarm }
    end
  end

  # GET /traffic_alarms/1/edit
  def edit
    @traffic_alarm = TrafficAlarm.find(params[:id])
    if params[:road]
      @road = Road.find(params[:road])
    end
    if @traffic_alarm.nil? || !check_owner(@traffic_alarm.device)
      flash[:warning] = "Unable to edit this alarm. Are you the owner?"
      redirect_to root_path
      return
    end
  end

  # POST /traffic_alarms
  # POST /traffic_alarms.xml
  def create
    @traffic_alarm = TrafficAlarm.new(params[:traffic_alarm])
    
    respond_to do |format|
      if @traffic_alarm.save
        flash[:notice] = 'TrafficAlarm was successfully created.'
        format.html { redirect_to(:action => "index") }
        format.xml  { render :xml => @traffic_alarm, :status => :created, :location => @traffic_alarm }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @traffic_alarm.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /traffic_alarms/1
  # PUT /traffic_alarms/1.xml
  def update
    @traffic_alarm = TrafficAlarm.find(params[:id])
    if @traffic_alarm.nil? || !check_owner(@traffic_alarm.device)
      flash[:warning] = "Unable to edit this alarm. Are you the owner?"
      redirect_to root_path
      return
    end
    
    # check whether the start_time is in the future
    if (@traffic_alarm.start_time.to_date > Time.zone.now.to_date)
      params[:traffic_alarm]["start_time(1i)"] = Time.zone.now.year.to_s
      params[:traffic_alarm]["start_time(2i)"] = Time.zone.now.month.to_s
      params[:traffic_alarm]["start_time(3i)"] = Time.zone.now.day.to_s
    end
    respond_to do |format|
      if @traffic_alarm.update_attributes(params[:traffic_alarm])
        flash[:notice] = 'TrafficAlarm was successfully updated.'
        # Uncomment the next line if we want to start sending emails
        # MailInterface.deliver_email(@traffic_alarm.device.email, "Alarm Update", "Traffic Trigger %i mpg" % @traffic_alarm.speed)
        format.html { redirect_to(root_path) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @traffic_alarm.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /traffic_alarms/1
  # DELETE /traffic_alarms/1.xml
  def destroy
    @traffic_alarm = TrafficAlarm.find(params[:id])
    @traffic_alarm.destroy

    respond_to do |format|
      format.html { redirect_to(traffic_alarms_url) }
      format.xml  { head :ok }
    end
  end
  
  # send updated list of available roads/freeways and ramps
  def roads
    respond_to do |format|
      #format.html { redirect_to(traffic_alarms_url) }
      format.text
      format.xml #  { render :xml => Road::all }
    end
  end
  
  # send out ramps
  def ramp_options
    html = ""
    if params[:road_id]
      road = Road.find(params[:road_id])
      road.ramps.each do |ramp|
        html += '<option value="%i">%s</option>' % [ramp.id, ramp.name]
      end
    end
    render :text => html
  end
  
end
