Rails.application.routes.draw do
  get 'quests/index'
  root 'pages#top'
  get 'pages/top'
  get 'pages/main'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }
  devise_scope :user do
    get '/users', to: 'devise/registrations#new'
  end
  
  get 'test', to: 'test#index'
end
