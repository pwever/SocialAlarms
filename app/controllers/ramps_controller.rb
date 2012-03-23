class RampsController < ApplicationController
  # GET /ramps
  # GET /ramps.xml
  def index
    @ramps = Ramp.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @ramps }
    end
  end

  # GET /ramps/1
  # GET /ramps/1.xml
  def show
    @ramp = Ramp.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @ramp }
    end
  end

  # GET /ramps/new
  # GET /ramps/new.xml
  def new
    @ramp = Ramp.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @ramp }
    end
  end

  # GET /ramps/1/edit
  def edit
    @ramp = Ramp.find(params[:id])
  end

  # POST /ramps
  # POST /ramps.xml
  def create
    @ramp = Ramp.new(params[:ramp])

    respond_to do |format|
      if @ramp.save
        flash[:notice] = 'Ramp was successfully created.'
        format.html { redirect_to(@ramp) }
        format.xml  { render :xml => @ramp, :status => :created, :location => @ramp }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @ramp.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /ramps/1
  # PUT /ramps/1.xml
  def update
    @ramp = Ramp.find(params[:id])

    respond_to do |format|
      if @ramp.update_attributes(params[:ramp])
        flash[:notice] = 'Ramp was successfully updated.'
        format.html { redirect_to(@ramp) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @ramp.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /ramps/1
  # DELETE /ramps/1.xml
  def destroy
    @ramp = Ramp.find(params[:id])
    @ramp.destroy

    respond_to do |format|
      format.html { redirect_to(ramps_url) }
      format.xml  { head :ok }
    end
  end
end
