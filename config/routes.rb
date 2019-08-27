Rails.application.routes.draw do
  get '/health', to: 'health#health'

  resources :posts, only: %i[index show]
end
