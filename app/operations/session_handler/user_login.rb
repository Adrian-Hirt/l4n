module Operations::SessionHandler
  class UserLogin < Operations::SessionHandler::SessionOperation
    schema3 do
      hsh! :login do
        str! :email
        str! :password
        str? :remember_me
      end
    end

    without_authorization

    def validation_errors
      super + [Operations::SessionHandler::LoginFailed]
    end

    def perform
      # rubocop:disable Style/GuardClause
      user = User.find_by(email: osparams.dig(:login, :email))

      # User exists, is activated and the password is correct
      if user&.activated? && user&.authenticate(osparams.dig(:login, :password))
        reset_session
        clean_remember_me_cookies
        context.session[:user_id] = user.id

        # If user wants to use the "remember me" feature,
        # create a new token and save it on the user model. Store
        # the token in a cookie, such that the user is logged in
        # when opening a browser with this cookie.
        if osparams.dig(:login, :remember_me)&.to_i == 1
          remember_me_token = SecureRandom.urlsafe_base64(32)
          user.update(remember_me_token: remember_me_token)
          cookies.permanent.encrypted[Session::REMEMBER_ME_USER_COOKIE] = {
            value:     user.id,
            same_site: :lax,
            http_only: true
          }
          cookies.permanent[Session::REMEMBER_ME_TOKEN_COOKIE] = {
            value:     remember_me_token,
            same_site: :lax,
            http_only: true
          }
        else
          user.update(remember_me_token: nil)
        end

        true
      else
        fail Operations::SessionHandler::LoginFailed
      end

      # rubocop:enable Style/GuardClause
    end
  end
end
