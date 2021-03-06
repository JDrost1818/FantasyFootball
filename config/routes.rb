Rails.application.routes.draw do
  devise_for :users
  resources :games

  resources :players
  get 'teams/:team_id/view_player/:id' => 'player#show'

  resources :users

  resources :teams
  get 'teams/:id/schedule' => 'teams#schedule'
  get 'teams/:id/add_player' => 'teams#free_agency'
  get 'teams/:id/add_player/:player_id' => 'teams#add_player'
  get 'teams/:id/rem_player/:player_id' => 'teams#rem_player'

  resources :leagues do
    resources :teams
  end
  get 'leagues/:id/addteam' => 'leagues#addteam'
  get 'leagues/:id/close' => 'leagues#close'
  get 'leagues/:id/advance_week' => "leagues#advance_week"

  root "users#show"


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
