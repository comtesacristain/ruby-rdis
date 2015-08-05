Rails.application.routes.draw do
  get 'borehole_mineral_attributes/index'

  get 'borehole_entity_attributes/index'

  get 'borehole_wdata_twos/index'

  get 'borehole_wdata_ones/index'

  get 'borehole_porperm_picks/index'

  get 'borehole_porperm_twos/index'

  get 'borehole_porperm_ones/index'

  get 'borehole_sidetracks/index'

  get 'borehole_resfacs_remarks/index'

  get 'borehole_stratigraphies/index'

  get 'borehole_dir_survey_stations/index'

  get 'borehole_dir_surveys/index'

  get 'borehole_resultws/index'

  get 'borehole_remarkws/index'

  get 'borehole_well_confids/index'

  get 'borehole_samples/index'

  get 'borehole_wells/index'

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
