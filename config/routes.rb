ActionController::Routing::Routes.draw do |map|
  
  map.root                        :controller => "devices", :action => "list"
  map.login        "/login",      :controller => "users",   :action => "login"
  map.logout       "/logout",     :controller => "users",   :action => "logout"
  map.activation   "/activate",   :controller => "devices", :action => "activate"
  map.link         "/link",       :controller => "devices", :action => "link"
  
  map.resources :devices
  map.resources :users
  
  map.resources :twitter_alarms
  map.roads     "/traffic_alarms/roads.:format", :controller => "traffic_alarms", :action => "roads"
  map.ramps     "/traffic_alarms/ramps.:format", :controller => "traffic_alarms", :action => "ramps"
  map.ramp_options     "/traffic_alarms/ramp_options", :controller => "traffic_alarms", :action => "ramp_options"
  map.resources :traffic_alarms
  map.beaches   "/surf_alarms/beaches.:format", :controller => "surf_alarms", :action => "beaches"
  map.resources :surf_alarms
  

  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
