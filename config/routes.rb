Rails.application.routes.draw do

  root 'homes#top'
  get 'homes/about', to: 'homes#about', as: 'about'
  post 'homes/guest_login', to: 'homes#guest_login'

  resources :servers

  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')
  get 'log_out', to: 'sessions#destroy', as: 'log_out'

  resources :sessions, only: %i[create destroy]

  devise_for :users, controllers: {
  }

  #devise_for :admins, path: 'admin/admins', controllers: {
  #  sessions: 'admin/admins/sessions'
  #}

  #namespace :admin do
  #  root 'home#top'
  #  resources :servers, only: [:index, :destroy]
  #end

  resources :users, only: [:show, :edit, :update] do
    member do
      get :favorites
    end
  end

  resources :servers, only: [:new, :create, :index, :show, :destroy] do
    resources :server_comments, only: [:create]
    resource :favorite, only: [:create, :destroy]
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "letter_opener"
  end
end
