# require "sidekiq/web"

Rails.application.routes.draw do
  mount Rswag::Ui::Engine => "/api-docs"
  mount Rswag::Api::Engine => "/api-docs"

  post "/graphql", to: "graphql#execute"

  get "/", to: "health_check#show"
  get "/up", to: "health_check#show"

  namespace :auth do
    resource :request, only: %i[create]
    resource :verification, only: %i[create]
  end

  resources :users, only: %i[show create update destroy]

  resource :session, only: %i[show create destroy]

  resources :what_to_discard_problems, only: %i[index create destroy] do
    resources :comments, module: :what_to_discard_problems, only: %i[index create destroy] do
      resources :replies, module: :comments, only: %i[index]
    end

    scope module: :what_to_discard_problems do
      namespace :votes do
        resource :my_vote, only: %i[show create destroy]
        resource :result, only: %i[show]
      end

      namespace :likes do
        resource :my_like, only: %i[show create destroy]
      end
    end
  end

  post "/graphql", to: "graphql#execute"

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end
