require "sidekiq/web"

Rails.application.routes.draw do
  post "/graphql", to: "graphql#execute"
  mount Rswag::Ui::Engine => "/api-docs"
  mount Rswag::Api::Engine => "/api-docs"

  mount ActiveStorage::Engine => "/rails/active_storage"

  get "/", to: "health_check#show"
  get "/up", to: "health_check#show"

  namespace :auth do
    namespace :google do
      resource :callback, only: %i[create]
    end

    namespace :line do
      resource :login_url, only: %i[show]
      resource :callback, only: %i[create]
    end
  end

  resource :session, only: %i[show]

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
    mount Sidekiq::Web => "/sidekiq"
  end
end
