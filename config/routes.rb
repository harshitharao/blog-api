Rails.application.routes.draw do
  resources :blogs
  post 'authenticate', to: 'authentication#authenticate'
end
