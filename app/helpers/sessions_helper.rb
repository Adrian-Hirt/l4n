module SessionsHelper
  def current_user
    @current_user ||= begin
      if (user_id = session[:user_id])
        User.find(session[:user_id])
      elsif (user_id = cookies.signed[:user_id])
        nil
      else
        cookies[:user_id] = nil
        nil
      end
    end
  end

  def logged_in?
    current_user.present?
  end

  def require_logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = 'Please log in'
      redirect_to login_url
    end
  end

  def redirect_back_or_root
    session.delete(:redirect_url)
    redirect_to(session[:redirect_url] || root_path)
  end

  def store_location
    session[:redirect_url] = request.original_url if request.get?
  end
end
