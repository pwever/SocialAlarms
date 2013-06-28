SampleApp::Application.routes.draw do

  root 'devices#list'

  get '/login' => 'users#login'
  post '/login' => 'users#login'
  get '/logout' => 'users#logout'
  get '/activate' => 'devices#activate'
  get '/deactivate' => 'devices#deactivate'
  get '/link' => 'devices#link'

  get '/traffic_alarms/roads.:format' => 'traffic_alarms#roads'
  get '/traffic_alarms/ramps.:format' => 'traffic_alarms#ramps'
  get '/traffic_alarms/ramp_options' => 'traffic_alarms#ramp_options'
  get '/surf_alarms/beaches.:format' => 'surf_alarms#beaches'

  resources :devices
  resources :users
  resources :twitter_alarms
  resources :traffic_alarms
  resources :surf_alarms

  
  
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end
  
  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
