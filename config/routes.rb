Rails.application.routes.draw do

  resource :users, only: [:new, :create]
  resource :sessions, only: [:new, :create, :destroy]
  resources :contacts
  resources :messages

  get "chats/show"
  root 'contacts#index'
end
