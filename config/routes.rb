# frozen_string_literal: true

Rails.application.routes.draw do
  root 'results#index'

  resources :results, only: %i[index]
  resources :players, only: %i[index show]
end
