Rails.application.routes.draw do
  mount ActionCable.server => '/cable'
  root 'pages#top'
  get 'pages/top'
  get 'pages/main'
  get 'pages/profile'
  get 'pages/withdraw'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }
  devise_scope :user do
    get '/users', to: 'devise/registrations#new'
    post '/users/guest_sign_in', to: 'users/sessions#guest_sign_in'
  end
  
  resources :quests do
    resources :rooms, only: [:show]
    collection do
      get 'my_quest'
    end
  end

  resources :challenges, except: [:new, :show, :edit] do
    collection do
      get 'closed'
    end
  end

  get 'test', to: 'test#index'
end
