# require "sidekiq/web"

Rails.application.routes.draw do
  # manifest.json へのリクエストを無視
  match "/manifest.json", to: proc { [404, {}, ["Not Found"]] }, via: :all

  get "/", to: "sessions#state"

  resources :users, expect: [ :new ]

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

  # resource :redis, only: %i[show]
  # mount Sidekiq::Web, at: "/sidekiq"
end
