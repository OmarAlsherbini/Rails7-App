Rails.application.routes.draw do
  resources :user_events
  resources :events
  # Devise (login/logout) for HTML requests
  devise_for :users, defaults: { format: :html },
    path: '',
    path_names: { sign_up: 'register' },
    controllers: {
      sessions: 'users/sessions',
      registrations: 'users/registrations',
      confirmations: 'users/confirmations'
    }
  devise_scope :user do
    get 'sign_in', to: 'devise/sessions#new'
    get 'register', to: 'devise/registrations#new'
    post 'register', to: 'devise/registrations#create'
    delete 'sign_out', to: 'devise/sessions#destroy'
    get 'confirmation/sent', to: 'confirmations#sent'
    get 'confirmation/:confirmation_token', to: 'confirmations#show'
    patch 'confirmation', to: 'confirmations#create'
  end
  
  # API namespace, for JSON requests at /api/sign_[in|out]
  namespace :api do
    devise_for :users, defaults: { format: :json },
      class_name: 'ApiUser',
      skip: [:registrations, :invitations,
        :passwords, :confirmations,
        :unlocks],
      path: '',
      path_names: { sign_in: 'login',
        sign_out: 'logout' }
    
    devise_scope :user do
      get 'login', to: 'devise/sessions#new'
      delete 'logout', to: 'devise/sessions#destroy'
    end
  end




  resources :month_apps
  resources :calendar_apps
  resources :test_children
  resources :test_parents
  resources :app_days
  resources :app_months 
  resources :app_years
  resources :app_calendars do
    get :app_year, on: :member
  end
  resources :posts
  resources :blogs
  get 'setup_proof/psql_test'
  get 'setup_proof/redis_test'
  get 'setup_proof/ruby_test'
  get 'setup_proof/turbo_test'
  get 'setup_proof/stimulus_test'
  get 'setup_proof/tailwind_test'
  get 'site/index'
  get 'events/get_user_events/:id', :to => 'events#get_user_events', :as => 'get_user_events'  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root to: "calendar_apps#index"
end










