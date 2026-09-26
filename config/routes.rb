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
        post 'drivers/invitation/verify_code', to: 'drivers/invitations#verify_code'
        post 'drivers/invitation/set_password', to: 'drivers/invitations#set_password'
        post 'drivers/invitation/accept', to: 'drivers/invitations#accept'
        resource :profile, only: %i[show update], module: :drivers, controller: 'profiles', path: 'drivers/profile'
        get 'drivers/home_data', to: 'drivers/home_data#show'
        get 'drivers/vehicle', to: 'drivers/vehicles#show'
        get 'drivers/history', to: 'drivers/trips#history'
        post 'drivers/location', to: 'drivers/locations#create'
        post 'drivers/refuels', to: 'drivers/refuels#create'
        post 'drivers/trips/:id/accept', to: 'drivers/trips#accept'
        patch 'drivers/trips/:id/status', to: 'drivers/trips#update_status'
        resources :notifications, only: [:index], module: :drivers, controller: 'notifications',
                                  path: 'drivers/notifications' do
          member do
            patch :read
          end
          collection do
            post :read_all
          end
        end
        resources :trips, only: %i[index show], module: :drivers, controller: 'trips', path: 'drivers/trips' do
          member do
            patch :update_status
          end
        end
      end
    end
  end

  resources :dashboard, only: [:index]
  resources :teams, only: [:index]
  get 'reports/print_pdf', to: 'reports#print_pdf', as: :print_pdf_reports
  resources :reports, only: [:index]
  get 'subscriptions', to: 'subscriptions#index', as: :subscriptions
  resource :subscription, only: %i[show update]

  resources :trips do
    member do
      patch :update_status
    end
  end

  resources :vehicles do
    member do
      post :assign_driver
      delete :unassign_driver
    end
  end

  resources :drivers do
    member do
      post :resend_invitation
    end
  end

  resources :clients
  resources :machineries
  resources :machinery_rentals do
    member do
      patch :complete
      patch :cancel
    end
  end
  resources :notifications, only: [:index] do
    member do
      patch :read
    end
    collection do
      post :read_all
    end
  end
  resources :payments, only: %i[index show new create]

  namespace :webhooks do
    post 'asaas', to: 'asaas#receive'
  end

  namespace :drivers do
    get 'welcome', to: 'welcome#index'
  end

  get 'up' => 'rails/health#show', :as => :rails_health_check

  authenticate :user, ->(u) { u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end
end
