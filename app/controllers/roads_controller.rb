class RoadsController < ApplicationController
  # GET /roads
  # GET /roads.xml
  def index
    @roads = Road.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @roads }
    end
  end

  # GET /roads/1
  # GET /roads/1.xml
  def show
    @road = Road.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @road }
    end
  end

  # GET /roads/new
  # GET /roads/new.xml
  def new
    @road = Road.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @road }
    end
  end

  # GET /roads/1/edit
  def edit
    @road = Road.find(params[:id])
  end

  # POST /roads
  # POST /roads.xml
  def create
    @road = Road.new(params[:road])

    respond_to do |format|
      if @road.save
        flash[:notice] = 'Road was successfully created.'
        format.html { redirect_to(@road) }
        format.xml  { render :xml => @road, :status => :created, :location => @road }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @road.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /roads/1
  # PUT /roads/1.xml
  def update
    @road = Road.find(params[:id])

    respond_to do |format|
      if @road.update_attributes(params[:road])
        flash[:notice] = 'Road was successfully updated.'
        format.html { redirect_to(@road) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @road.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /roads/1
  # DELETE /roads/1.xml
  def destroy
    @road = Road.find(params[:id])
    @road.destroy

    respond_to do |format|
      format.html { redirect_to(roads_url) }
      format.xml  { head :ok }
    end
  end
end
