module Operations::SessionHandler
  class CreateSession < Operations::SessionHandler::SessionOperation
    schema3 do
      obj! :user, classes: [User], strict: false
      boo! :remember_me
    end

    without_authorization

    def perform
      reset_session
      clean_remember_me_cookies
      context.session[:user_id] = osparams.user.id

      # If user wants to use the "remember me" feature,
      # create a new token and save it on the user model. Store
      # the token in a cookie, such that the user is logged in
      # when opening a browser with this cookie.
      if osparams.remember_me
        remember_me_token = SecureRandom.urlsafe_base64(32)
        osparams.user.update!(remember_me_token: remember_me_token, remember_me_token_created_at: Time.zone.now)
        cookies.permanent.encrypted[Session::REMEMBER_ME_USER_COOKIE] = {
          value:     osparams.user.id,
          same_site: :lax,
          http_only: true
        }
        cookies.permanent[Session::REMEMBER_ME_TOKEN_COOKIE] = {
          value:     remember_me_token,
          same_site: :lax,
          http_only: true
        }
      else
        osparams.user.update(remember_me_token: nil)
      end

      true
    end
  end
end
