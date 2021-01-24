Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  get 'ping', to: 'ping#ping'

  get 'home', to: 'global/home#index'
  options 'home', to: 'cors#allow'

  get 'contents/:id', to: 'global/contents#show'
  options 'contents/:id', to: 'cors#allow'
  post 'contents', to: 'global/contents#create'
  options 'contents', to: 'cors#allow'
  post 'contents/:id/comment', to: 'global/content_comments#comment'
  options 'contents/:id/comment', to: 'cors#allow'
  post 'contents/:id/like', to: 'global/content_likes#like'
  options 'contents/:id/like', to: 'cors#allow'
  post 'contents/:id/unlike', to: 'global/content_likes#unlike'
  options 'contents/:id/unlike', to: 'cors#allow'
  get 'content_comments/:id', to: 'global/content_comments#index'
  options 'content_comments/:id', to: 'cors#allow'

  get 'categories', to: 'global/categories#index'
  options 'categories', to: 'cors#allow'

  post 'users/register', to: 'global/users#register'
  options 'users/register', to: 'cors#allow'
  post 'users/login', to: 'global/users#login'
  options 'users/login', to: 'cors#allow'

  get 'profile/me', to: 'global/profile#me'
  options 'profile/me', to: 'cors#allow'
  get 'profile/:id/info', to: 'global/profile#info'
  options 'profile/:id/info', to: 'cors#allow'
end
