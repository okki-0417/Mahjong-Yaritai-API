# require "sidekiq/web"

Rails.application.routes.draw do
  # manifest.json へのリクエストを無視
  match "/manifest.json", to: proc { [404, {}, ["Not Found"]] }, via: :all

  get "/", to: "sessions#state"

  resources :users, only: %i[index create edit create update destroy]

  namespace :users do
    resource :verification, only: %i[create]
    resource :verification_confirmation, only: %i[show]
  end

  resource :session, only: [ :new, :create, :destroy ] do
    collection do
      get :state
    end
  end

  resource :csrf_token, only: [ :show ]

  resources :reports

  resource :profile, only: [ :show, :update ]

  resources :forum_threads do
    resources :threads_comments
  end

  resources :what_to_discard_problems do
    resources :comments, module: :what_to_discard_problems
  end

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

  # resource :redis, only: %i[show]
  # mount Sidekiq::Web, at: "/sidekiq"
end
