Rails.application.routes.draw do
  
  resource :users, only: [:new, :create]
  resource :sessions, only: [:new, :create, :destroy]

  root 'welcome#index'
end
