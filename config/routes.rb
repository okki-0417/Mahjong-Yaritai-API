# require "sidekiq/web"

Rails.application.routes.draw do
  get "/", to: "sessions#show"

  resource :authorization_session, only: %i[create]
  resource :authorization, only: %i[create]

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

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end
