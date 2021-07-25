module SessionsHelper
  def current_user
    @current_user ||= begin
      if (user_id = session[:user_id])
        result = User.find_by(id: user_id)
      elsif (user_id = cookies.encrypted[Session::REMEMBER_ME_USER_COOKIE])
        temp_user = User.find_by(id: user_id)

        if temp_user
          token_valid = temp_user.authenticate_remember_me_token(cookies[Session::REMEMBER_ME_TOKEN_COOKIE])
          token_expired = (temp_user.remember_me_token_created_at + User::REMEMBER_ME_TOKEN_EXPIRES_AFTER) <= Time.zone.now

          if token_valid && !token_expired
            reset_session
            session[:user_id] = temp_user.id
            result = temp_user
          else
            cookies.delete(Session::REMEMBER_ME_USER_COOKIE)
            cookies.delete(Session::REMEMBER_ME_TOKEN_COOKIE)
            result = nil
          end
        else
          cookies.delete(Session::REMEMBER_ME_USER_COOKIE)
          cookies.delete(Session::REMEMBER_ME_TOKEN_COOKIE)
          result = nil
        end
      else
        result = nil
      end

      result
    end
  end

  def logged_in?
    current_user.present?
  end
end
