Rails.application.routes.draw do
  get 'led/play'

  get 'led/stop'

  get 'led/flash'

  resources :songs
  
  root 'songs#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
