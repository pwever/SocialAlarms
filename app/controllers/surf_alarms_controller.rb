class SurfAlarmsController < ApplicationController
  
  before_filter :admin_check, :except => [:edit, :update, :beaches]
  
  # GET /surf_alarms
  # GET /surf_alarms.xml
  def index
    @surf_alarms = SurfAlarm.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @surf_alarms }
    end
  end

  # GET /surf_alarms/1
  # GET /surf_alarms/1.xml
  def show
    @surf_alarm = SurfAlarm.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @surf_alarm }
    end
  end

  # GET /surf_alarms/new
  # GET /surf_alarms/new.xml
  def new
    @surf_alarm = SurfAlarm.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @surf_alarm }
    end
  end

  # GET /surf_alarms/1/edit
  def edit
    @surf_alarm = SurfAlarm.find(params[:id])
    if @surf_alarm.nil? || !check_owner(@surf_alarm.device)
      flash[:warning] = "Unable to edit this alarm. Are you the owner?"
      redirect_to root_path
      return
    end
  end

  # POST /surf_alarms
  # POST /surf_alarms.xml
  def create
    @surf_alarm = SurfAlarm.new(params[:surf_alarm].permit!)

    respond_to do |format|
      if @surf_alarm.save
        flash[:notice] = 'SurfAlarm was successfully created.'
        format.html { redirect_to(:action => "index") }
        format.xml  { render :xml => @surf_alarm, :status => :created, :location => @surf_alarm }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @surf_alarm.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /surf_alarms/1
  # PUT /surf_alarms/1.xml
  def update
    @surf_alarm = SurfAlarm.find(params[:id])
    if @surf_alarm.nil? || !check_owner(@surf_alarm.device)
      flash[:warning] = "Unable to edit this alarm. Are you the owner?"
      redirect_to root_path
      return
    end
    
    # check whether the start_time is in the future
    if (@surf_alarm.start_time.to_date > Time.zone.now.to_date)
      params[:surf_alarm]["start_time(1i)"] = Time.zone.now.year.to_s
      params[:surf_alarm]["start_time(2i)"] = Time.zone.now.month.to_s
      params[:surf_alarm]["start_time(3i)"] = Time.zone.now.day.to_s
    end
    respond_to do |format|
      if @surf_alarm.update_attributes(params[:surf_alarm])
        flash[:notice] = 'SurfAlarm was successfully updated.'
        # Uncomment the next line if we want to start sending emails
        # MailInterface.deliver_email(@surf_alarm.device.email, "Alarm Update", "Surf Trigger %i ft" % @surf_alarm.wave_height)
        format.html { redirect_to(root_path) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @surf_alarm.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /surf_alarms/1
  # DELETE /surf_alarms/1.xml
  def destroy
    @surf_alarm = SurfAlarm.find(params[:id])
    @surf_alarm.destroy

    respond_to do |format|
      format.html { redirect_to(surf_alarms_url) }
      format.xml  { head :ok }
    end
  end
  
  # return current beach data
  def beaches
    p "surf_alarm beach action"
    respond_to do |format|
      format.text
      format.xml
    end
  end
end
