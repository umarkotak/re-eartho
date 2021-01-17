Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  get 'ping', to: 'ping#ping'

  get 'home', to: 'global/home#index'
  options 'home', to: 'cors#allow'

  get 'contents/:id', to: 'global/contents#show'
  options 'contents/:id', to: 'cors#allow'
  post 'contents', to: 'global/contents#create'
  options 'contents', to: 'cors#allow'

  get 'categories', to: 'global/categories#index'
  options 'categories', to: 'cors#allow'

  post 'users/register', to: 'global/users#register'
  options 'users/register', to: 'cors#allow'
  post 'users/login', to: 'global/users#login'
  options 'users/login', to: 'cors#allow'
end
