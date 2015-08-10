EnrichingWeChat::Application.routes.draw do
  root to: 'customers#welcome'

  get 'wechat', to: 'we_chat#auth_token'
  get 'point_exchanges/show_remain_point', to: 'point_exchanges#show_remain_point'
  get 'point_exchanges/:id/show_remain_point', to: 'point_exchanges#show_remain_point'
  get 'wechat/addmenu', to: 'we_chat#addmenu'
  get 'wechat/fetch_material_list', to: 'we_chat#fetch_material_list'

  post 'wechat', to: 'we_chat#msg_post'

  scope :path => "/wechat", :via => :post do
     match "/", :to => 'we_chat#method_text', :constraints => lambda { |request| request.params[:xml][:MsgType] == 'text' }
     match "/", :to => 'we_chat#method_image', :constraints => lambda { |request| request.params[:xml][:MsgType] == 'image' }
     match "/", :to => "we_chat#method_location",:constraints => lambda { |request| request.params[:xml][:MsgType] == 'location' }
     match "/", :to => "we_chat#method_event",:constraints => lambda { |request| request.params[:xml][:MsgType] == 'event'}
  end

  resources :point_exchanges, except: [:edit, :update]

  resources :coupons

  resources :customer_points

  resources :customers

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
