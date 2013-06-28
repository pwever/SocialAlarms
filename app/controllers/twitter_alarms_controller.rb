class TwitterAlarmsController < ApplicationController
  
  before_filter :admin_check, :except => [:edit, :update]
  
  # GET /twitter_alarms
  # GET /twitter_alarms.xml
  def index
    @twitter_alarms = TwitterAlarm.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @twitter_alarms }
    end
  end

  # GET /twitter_alarms/1
  # GET /twitter_alarms/1.xml
  def show
    @twitter_alarm = TwitterAlarm.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @twitter_alarm }
    end
  end

  # GET /twitter_alarms/new
  # GET /twitter_alarms/new.xml
  def new
    @twitter_alarm = TwitterAlarm.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @twitter_alarm }
    end
  end

  # GET /twitter_alarms/1/edit
  def edit
    @twitter_alarm = TwitterAlarm.find(params[:id])
    if @twitter_alarm.nil? || !check_owner(@twitter_alarm.device)
      flash[:warning] = "Unable to edit this alarm. Are you the owner?"
      redirect_to root_path
      return
    end
  end

  # POST /twitter_alarms
  # POST /twitter_alarms.xml
  def create
    @twitter_alarm = TwitterAlarm.new(params[:twitter_alarm].permit!)

    respond_to do |format|
      if @twitter_alarm.save
        flash[:notice] = 'TwitterAlarm was successfully created.'
        format.html { redirect_to(:action => "index") }
        format.xml  { render :xml => @twitter_alarm, :status => :created, :location => @twitter_alarm }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @twitter_alarm.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /twitter_alarms/1
  # PUT /twitter_alarms/1.xml
  def update
    @twitter_alarm = TwitterAlarm.find(params[:id])
    if @twitter_alarm.nil? || !check_owner(@twitter_alarm.device)
      flash[:warning] = "Unable to edit this alarm. Are you the owner?"
      redirect_to root_path
      return
    end

    # check whether the start_time is in the future
    if (@twitter_alarm.start_time.to_date > Time.zone.now.to_date)
      params[:twitter_alarm]["start_time(1i)"] = Time.zone.now.year.to_s
      params[:twitter_alarm]["start_time(2i)"] = Time.zone.now.month.to_s
      params[:twitter_alarm]["start_time(3i)"] = Time.zone.now.day.to_s
    end
    respond_to do |format|
      if @twitter_alarm.update_attributes(params[:twitter_alarm])
        flash[:notice] = 'TwitterAlarm was successfully updated.'
        # Uncomment the next line if we want to start sending emails
        # MailInterface.deliver_email(@twitter_alarm.device.email, "Alarm Update", "Twitter Trigger %i tpm" % @twitter_alarm.volume)
        format.html { redirect_to(root_path) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @twitter_alarm.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /twitter_alarms/1
  # DELETE /twitter_alarms/1.xml
  def destroy
    @twitter_alarm = TwitterAlarm.find(params[:id])
    @twitter_alarm.destroy

    respond_to do |format|
      format.html { redirect_to(twitter_alarms_url) }
      format.xml  { head :ok }
    end
  end
end
