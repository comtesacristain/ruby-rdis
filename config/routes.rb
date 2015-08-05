Rails.application.routes.draw do
  get 'mineral_attributes/index'

  get 'entity_attributes/index'

  get 'wdata_twos/index'

  get 'wdata_ones/index'

  get 'porperm_picks/index'

  get 'porperm_twos/index'

  get 'porperm_ones/index'

  get 'sidetracks/index'

  get 'resfacs_remarks/index'

  get 'stratigraphies/index'

  get 'dir_survey_stations/index'

  get 'dir_surveys/index'

  get 'resultws/index'

  get 'remarkws/index'

  get 'well_confids/index'

  get 'samples/index'

  get 'wells/index'

  resources :duplicates do
    member do
      put :qa
      patch :qa
      
    end
    collection do 
      get :backup
    end
  end
  
  resources :boreholes 
  
  resources :borehole_wells
  resources :borehole_mineral_attributes
  resources :borehole_entity_attributes
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
