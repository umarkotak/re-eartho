Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  get 'ping', to: 'ping#ping'
  get 'home', to: 'global/home#index'
  options 'home', to: 'cors#allow'
  get 'contents/:id', to: 'global/contents#show'
end
