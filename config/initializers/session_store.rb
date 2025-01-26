Rails.application.config.session_store :cookie_store,
                                      expire_after: 20.years,
                                      domain: ENV.fetch("FRONTEND_DOMAIN"),
                                      secure: Rails.env.production?
