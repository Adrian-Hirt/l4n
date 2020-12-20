module SessionsHelper
  def current_user
    @current_user ||= begin
      if (user_id = session[:user_id])
        User.find(user_id)
      elsif (user_id = cookies.encrypted[:user_id])
        temp_user = User.find(user_id)
        return temp_user if temp_user.authenticate_remember_me_token(cookies[:remember_token])

        cookies.delete(:user_id)
        return nil
      else
        cookies.delete(:user_id)
        return nil
      end
    end
  end

  def logged_in?
    current_user.present?
  end
end
