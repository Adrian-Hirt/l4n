module AdminLayoutHelper
  def admin_body_classes
    classes = []
    classes << 'sidebar-collapse' if cookies['_l4n_admin_sidebar_collapsed'].present?
    classes << 'dark-mode' if current_user.use_dark_mode?
    classes
  end

  def admin_header_classes
    classes = []
    if current_user.use_dark_mode?
      classes << 'navbar-dark'
    else
      classes << 'navbar-light navbar-white'
    end
    classes
  end

  def admin_sidebar_classes
    sidebar_mode = current_user.use_dark_mode? ? 'sidebar-dark' : 'sidebar-light'
    ["#{sidebar_mode}-primary"]
  end
end
