Rails.application.routes.draw do
  resources :app_days
  resources :app_months
  resources :app_years
  resources :app_calendars
  resources :posts
  resources :blogs
  get 'setup_proof/psql_test'
  get 'setup_proof/redis_test'
  get 'setup_proof/ruby_test'
  get 'setup_proof/turbo_test'
  get 'setup_proof/stimulus_test'
  get 'setup_proof/tailwind_test'
  get 'site/index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
