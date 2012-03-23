class DevicesController < ApplicationController
  
  before_filter :admin_check, :except => [:list, :activate, :link, :deactivate, :edit, :update]
  
  def list
    # lists the devices specific to this user
    @devices = @account.devices

    respond_to do |format|
      format.html
      format.xml  { render :xml => @devices }
    end
  end
  
  def activate
    params[:device] = {} if params[:device].nil?
    params[:user] = {} if params[:user].nil?
    render
  end
    
  def link
    params[:device] = {} if params[:device].nil?
    params[:user] = {} if params[:user].nil?
    
    
    # Try to login
    if params[:user][:username]
      @account = User.find(:first, :conditions => params[:user])
      session[:username] = @account.username if @account
    end
    
    
    
    # Check for problems
    # with the device
    
    @device = Device.find(:first, :conditions => params[:device]) if params[:device]
    
    if @device.nil?
      # Device does not exist
      flash.now[:error] = "We were not able to identify your device. Please check the IMEI."
      render :action => "activate"
      return
    end
    
    if (@device.user)
      # Device is already registered
      if (@account && @device.user.username == @account.username)
        # to the current user
        flash[:notice] = "This device is already under your controll."
        redirect_to(:action => "list")
        return
      else
        # to another user
        flash.now[:error] = "Another user has already activate this device.<br />Please tell <b>#{@device.user.username}</b> to unregister it first."
        render :action => "activate"
        return
      end
    end
    
    
    
    # if there were no problems
    # make sure we create the user account
    # if it doesn't exist already
    if @account.nil? && params[:user][:username]
      @account = User.new(params[:user])
      unless @account.save
        flash.now[:error] = "Unable to create this user."
        render :action => "activate"
        return
      end
    end
    session[:username] = @account.username
    
    
    
    # there is a device with this id
    # and there is a user (new or old)
    
    if @device && @account
      @device.user = @account
      @device.create_new_alarms
      @device.enabled = true
      @device.save
      flash[:notice] = "Device '#{@device.imei}' has been activated."
      redirect_to(:action => "list")
    end
    
  end
  
  def deactivate
    @device = Device.find(params[:id])
    
    if @device && @account && @device.user.username==@account.username
      @device.user = nil
      @device.save
    end
    
    redirect_to(:action => "list")
  end
  
  def toggle
    @device = Device.find(params[:id])
    @device.enabled = !@device.enabled
    if @device.save
      render :text => @device.enabled ? "Disable" : "Enable"
    end
  end
  
  
  
  # DEFAULT SCAFFOLDING
  
  # GET /devices
  # GET /devices.xml
  def index
    @devices = Device.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @devices }
    end
  end

  # GET /devices/1
  # GET /devices/1.xml
  def show
    @device = Device.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @device }
    end
  end

  # GET /devices/new
  # GET /devices/new.xml
  def new
    @device = Device.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @device }
    end
  end

  # GET /devices/1/edit
  def edit
    @device = Device.find(params[:id])
    if !check_owner(@device)
      flash[:warning] = "Unable to edit this device. Are you the owner?"
      redirect_to root_path
      return
    end
  end

  # POST /devices
  # POST /devices.xml
  def create
    @device = Device.new(params[:device])

    respond_to do |format|
      if @device.save
        flash[:notice] = 'Device was successfully created.'
        format.html { redirect_to(@device) }
        format.xml  { render :xml => @device, :status => :created, :location => @device }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @device.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /devices/1
  # PUT /devices/1.xml
  def update
    @device = Device.find(params[:id])
    if !check_owner(@device)
      flash[:warning] = "Unable to edit this device. Are you the owner?"
      redirect_to root_path
      return
    end

    respond_to do |format|
      if @device.update_attributes(params[:device])
        flash[:notice] = 'Device was successfully updated.'
        format.html { redirect_to(root_path) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @device.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /devices/1
  # DELETE /devices/1.xml
  def destroy
    @device = Device.find(params[:id])
    @device.destroy

    respond_to do |format|
      format.html { redirect_to(devices_url) }
      format.xml  { head :ok }
    end
  end
end
