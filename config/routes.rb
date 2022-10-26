Rails.application.routes.draw do
  resources :user_events
  resources :events
  devise_for :users, path: '', path_names: {
    sign_in: 'login',
    sign_out: 'logout',
    registration: 'signup'
  },
  controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
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