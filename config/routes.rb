# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :admin_users, controllers: {
    sessions: 'admin_users/sessions',
    passwords: 'admin_users/passwords'
  }
  root to: 'home#index'

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  resources :workshops, only: %i[index show]
  resources :bookings, only: :create do
    get :booking_details, on: :member
  end

  resources :refunds do
    get :refund_acceptance, on: :member
  end

  namespace :admin do
    get 'dashboard', to: 'dashboard#index'
    resources :workshops
    resources :bookings
    resources :customers
    resources :refunds do
      member do
        patch :process_refund
      end
    end
  end

end
