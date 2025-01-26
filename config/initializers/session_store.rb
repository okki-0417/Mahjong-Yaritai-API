Rails.application.config.session_store :cookie_store,
                                      expire_after: 20.years,
                                      path: ENV.fetch("FRONTEND_DOMAIN"),
                                      secure: Rails.env.production?
