# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :people, except: %i[new edit]
      resources :lotteries, only: %i[create]
    end
  end
end
