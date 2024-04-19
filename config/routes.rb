# frozen_string_literal: true

Rails.application.routes.draw do
  root 'results#index'

  resources :results, only: %i[index]
  resources :players, only: %i[index show]

  get 'health_error' => 'home#health_error'
  get 'health' => 'home#health'
end
