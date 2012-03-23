# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  
  helper :all # include all helpers, all the time
  protect_from_forgery :except => [:roads, :ramps, :beaches]
  # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  
  before_filter :identify
  before_filter :authorize, :except => [:login, :logout, :activate, :link, :roads, :ramps, :beaches]
  
  
  private
  
  def identify
    if session[:username] then
      @account = User.find(:first, :conditions => { :username => session[:username] })
    else
      @account = nil
    end
  end
  
  def authorize
    if @account.nil?
      flash[:warning] = "Please login first."
      redirect_to( login_path )
    else
      set_user_time_zone
    end
    
  end
  
  def admin_check
    if @account.admin
      @admin_only_page = true
    else
      flash[:notice] = "Please login as an admin user."
      redirect_to( login_path )
    end
  end
  
  def check_owner(device)
    return (@account && @account.admin || (device.user && @account.username==device.user.username))
  end
  
  def set_user_time_zone
    Time.zone = @account.time_zone
  end
  
end
