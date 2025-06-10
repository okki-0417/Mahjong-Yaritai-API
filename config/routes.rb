# require "sidekiq/web"

Rails.application.routes.draw do
  post "/graphql", to: "graphql#execute"

  get "/", to: "health_check#show"
  get "/up", to: "health_check#show"

  resource :authorization_session, only: %i[create]
  resource :authorization, only: %i[create show]

  resources :users, only: %i[show create update destroy]

  resource :session, only: %i[show create destroy]
  resource :csrf_token, only: [ :show ]

  resources :what_to_discard_problems, only: %i[index create destroy] do
    resources :comments, module: :what_to_discard_problems
    resources :likes, module: :what_to_discard_problems, only: %i[index create destroy]
    resources :votes, module: :what_to_discard_problems, only: %i[index create destroy]

    scope module: :what_to_discard_problems do
      namespace :votes do
        resource :my_vote, only: %i[show]
      end
    end
  end

  post "/graphql", to: "graphql#execute"

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end
