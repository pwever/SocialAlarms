class UsersController < ApplicationController
  
  before_filter :admin_check, :except => [:login, :logout, :edit, :update]
  
  def login
    # check whether we are logging in
    if (params[:username] && params[:password]) then
      # test validity
      @account = User.find(:first, :conditions => { :username => params[:username]})
      if !@account.nil? && @account.password==params[:password] then
        session[:username] = @account.username
        flash[:notice] = "Login successful."
        redirect_to( :controller => "devices", :action => "list" )
        return
      else
        flash.now[:error] = "Please try again."
      end
    end
    render
  end
  
  def logout
    session[:username] = nil
    session[:destination] = nil
    flash[:notice] = "You have been logged out."
    redirect_to(:action => :login)
  end
  
  
  
  
  
  
  
  # GENERIC SCAFFOLDING
  
  # GET /users
  # GET /users.xml
  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
    unless @account.admin || @account.username==@user.username
      flash[:warning] = "You do not have enough access rights to edit this user."
      redirect_to root_path
      return
    end
  end

  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        flash[:notice] = 'User was successfully created.'
        format.html { redirect_to(@user) }
        format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = User.find(params[:id])
    unless @account.admin || @account.username==@user.username
      flash[:warning] = "You do not have enough access rights to edit this user."
      redirect_to root_path
      return
    end

    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = 'User was successfully updated.'
        format.html { redirect_to(root_path) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
    end
  end
end

