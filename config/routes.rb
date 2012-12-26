require 'resque/server'
require 'resque_scheduler'
require 'resque_scheduler/server'

Sengine::Application.routes.draw do

  namespace :sys do
    root to: "home#index"
    resources :feedbacks do
      member do
        put :publish
        put :success
        put :unpublish
        put :unsuccess
      end
    end

    resources :games, only: [:destroy, :edit, :index, :show, :update]

    resources :tags, only: [:create, :edit, :index, :new, :show, :update]

    resources :users, only: [:destroy, :edit, :index, :show, :update] do
      member do
        put :unset_admin
        put :set_admin
      end
    end
  end

  mount Resque::Server.new, at: "/sys/resque"

  %w(game privacy tos).each do |page|
    match "about/#{page}", as: "about_#{page}"
  end

  get "help", to: 'help#index', as: :help

  devise_for :users,
    controllers: { omniauth_callbacks: "devise_omniauth_callbacks", sessions: "devise_sessions" }

  get "audio/encode/*filename", to: 'audio#encode'

  resources :feedbacks, only: [:create, :index, :show] do
    collection do
      get :success
    end
    member do
      put :dislike
      put :like
    end
  end

  get "games/opponent_fields", to: "games#opponent_fields", as: "opponent_fields_game"
  resources :games, only: [:create, :destroy, :new, :index, :show] do
    resources :comments, only: [:create, :destroy, :new, :index, :show] do
      collection do
        get :check_update
      end
    end
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

  resources :pushes, only: [:index]

  match "tags/search/:q", to: 'tags#search'
  resources :tags, only: [:create, :destroy, :index, :show] do
    collection do
      get :search
    end
  end
  get "setting", to: "setting#show", as: :setting
  get "setting/edit", to: "setting#edit", as: :edit_setting
  get "setting/edit/:objective", to: "setting#edit", as: :edit_setting_objective
  put "setting", to: "setting#update"

  root to: "home#index"
  root to: "home#top"
  root to: "home#mypage"

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
