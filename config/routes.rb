require "sidekiq/web"

Rails.application.routes.draw do
  post "/graphql", to: "graphql#execute"
  mount Rswag::Ui::Engine => "/api-docs"
  mount Rswag::Api::Engine => "/api-docs"

  # 他のルーティング定義の下に追加
  mount ActiveStorage::Engine => "/rails/active_storage"

  get "/", to: "health_check#show"
  get "/up", to: "health_check#show"

  namespace :auth do
    resource :request, only: %i[create]
    resource :verification, only: %i[create]

    namespace :google do
      resource :login, only: %i[show]
      resource :callback, only: %i[create]
    end

    namespace :line do
      resource :login_url, only: %i[show]
      resource :callback, only: %i[create]
    end
  end

  resource :session, only: %i[show destroy]

  namespace :me do
    resource :profile, only: %i[show update]
  end

  namespace :learnings do
    resources :categories, only: %i[index show] do
      resources :questions, only: %i[index show]
    end
  end

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
    mount Sidekiq::Web => "/sidekiq"
  end
end
