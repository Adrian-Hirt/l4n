module Operations::SessionHandler
  class SessionOperation < RailsOps::Operation
    def perform
      fail NotImplementedError
    end

    private
    
    def clean_remember_me_cookies
      cookies.delete(Session::REMEMBER_ME_USER_COOKIE)
      cookies.delete(Session::REMEMBER_ME_TOKEN_COOKIE)
    end

    def reset_session
      context.view.controller.reset_session
    end

    def cookies
      context.view.controller.send(:cookies)
    end
  end

  class LoginFailed < StandardError; end
end
