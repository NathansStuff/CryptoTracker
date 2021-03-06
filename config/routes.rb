Rails.application.routes.draw do
  resources :purchases
  resources :cryptos
  devise_for :users
  root 'home#about'

  get 'home/about'
  get 'home/lookup'
  post 'home/lookup' => 'home/lookup'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
