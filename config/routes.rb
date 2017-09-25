Rails.application.routes.draw do
  resources :tracks, only: %i(new create)
  get '/tv', to: 'games#tv'
  root 'tracks#new'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
