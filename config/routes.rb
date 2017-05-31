Rails.application.routes.draw do
  root 'welcome#index'

  resource :users, only: [:new, :create]
end
