Rails.application.routes.draw do
  devise_for :users, path: '/users', path_names: {
    sign_in: 'login',
    sign_out: 'logout',
    registration: 'signup'
  },
  controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  # root "users/url#redirect"
  get '/:short_url', to: 'users/url#redirect'
  
  namespace :users do
    
    get '/top_visits', to: 'url#top_visits'

    resources :url, only: [:index, :show, :create, :destroy]
  end
end
