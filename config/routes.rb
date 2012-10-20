Shogiengine::Application.routes.draw do

  resources :comments

  namespace :sys do
    root to: "home#index"
    resources :feedbacks do
      member do
        put :publish
        put :unpublish
      end
    end

    resources :games, only: [:destroy, :edit, :index, :show, :update]

    resources :users, only: [:destroy, :edit, :index, :show, :update] do
      member do
        put :unset_admin
        put :set_admin
      end
    end
  end

  %w(game privacy tos).each do |page|
    match "about/#{page}", as: "about_#{page}"
  end

  get "help", to: 'help#index', as: :help

  devise_for :users,
    controllers: { omniauth_callbacks: "devise_omniauth_callbacks", sessions: "devise_sessions" }

  get "audio/encode/*filename", to: 'audio#encode'

  resources :feedbacks, only: [:create, :index, :show]

  resources :games, only: [:create, :destroy, :new, :index, :show] do
    resources :movements
    collection do
      get :friends
      get :mine
      get :playing
    end
    member do
      get :check_update
      put :give_up
    end
  end

  get "notices", to: "home#notices", as: :notices

  get "profile/:id", to: "profile#show", as: :profile
  get "profile/:user_id/games", to: "games#index"

  get "setting", to: "setting#show", as: :setting
  get "setting/edit", to: "setting#edit", as: :edit_setting
  put "setting", to: "setting#update"

  root to: "home#index"

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
