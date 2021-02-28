module Operations::SessionHandler
  class UserLogout < Operations::SessionHandler::SessionOperation
    schema3 do
      obj! :user, classes: ::User
    end

    without_authorization
    
    def perform
      osparams.user.update(remember_me_token: nil)
      clean_remember_me_cookies
      reset_session
    end
  end
end
