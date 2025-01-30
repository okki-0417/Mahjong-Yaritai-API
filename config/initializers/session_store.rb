Rails.application.config.session_store :redis_store,
                                      expire_after: 20.years,
                                      secure: true,
                                      httponly: true
