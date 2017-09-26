Rails.application.routes.draw do
  resources :tracks, only: %i(index new create)
  resources :players, only: %i(new create)
  resources :games, only: %i(create update) do
    post :answer, on: :member
  end
  get '/tv', to: 'games#tv'
  root 'games#index'
end
