# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  authenticated :user do
    root to: 'dashboard#index', as: :authenticated_root
  end
  root 'home#index'

  devise_for :users, controllers: {
    invitations: 'users/invitations'
  }

  devise_for :drivers, skip: [:sessions], controllers: {
    invitations: 'drivers/invitations'
  }

  namespace :api do
    namespace :v1 do
      devise_scope :driver do
        post 'drivers/login', to: 'drivers/sessions#create'
        delete 'drivers/logout', to: 'drivers/sessions#destroy'
        post 'drivers/invitation/accept', to: 'drivers/invitations#accept'
        resource :profile, only: %i[show update], module: :drivers, controller: 'profiles', path: 'drivers/profile'
      end
    end
  end

  resources :dashboard, only: [:index]
  resources :teams, only: [:index]

  namespace :drivers do
    get 'welcome', to: 'welcome#index'
  end

  get 'up' => 'rails/health#show', :as => :rails_health_check

  authenticate :user, ->(u) { u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end
end
