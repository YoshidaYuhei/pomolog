Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :health_checks, only: %i[index]
      resources :password_resets, only: %i[create update edit]
      post 'users/login', to: 'users#login'
      post 'users/signup', to: 'users#create'
      post 'users/logout', to: 'users#logout'

      resources :diaries, only: %i[create]
    end
  end
end
