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

  resources :dashboard, only: [:index]
  resources :teams, only: [:index]

  get 'up' => 'rails/health#show', :as => :rails_health_check

  authenticate :user, ->(u) { u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end
end
