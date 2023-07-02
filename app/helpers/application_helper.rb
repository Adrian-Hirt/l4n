module ApplicationHelper
  def flash_messages(_opts = {})
    flash.each do |msg_type, message|
      concat(content_tag(:div, message,
                         class: "alert alert-#{msg_type} alert-dismissible fade show notification-flash",
                         role:  'alert',
                         data:  {
                           controller: 'alert'
                         }) do
               concat content_tag(:button, nil, class: 'btn-close', data: { 'bs-dismiss': 'alert' })
               concat message
             end)
    end
    nil
  end

  def admin_page_title
    breadcrumbs_on_rails.map(&:name).join(' > ')
  end

  def page_title
    titles = [AppConfig.application_name]
    titles += breadcrumbs_on_rails.drop(1).map(&:name)
    titles.join(' > ')
  end

  def lan_party_progress_bar(lan_party)
    render partial: 'shared/lan_party_progress_bar', locals: { lan_party: lan_party }
  end

  def color_theme
    # If the user is set, take the value from the users account
    return current_user.color_theme_preference if current_user

    # Otherwise, check if we have a cookie for the theme
    return cookies[:_l4n_color_theme] if cookies[:_l4n_color_theme].present?

    # Otherwise, fall-back to 'auto'
    'auto'
  end

  def color_theme_active_classes(name, other_classes)
    return "active #{other_classes}" if color_theme == name

    other_classes
  end
end
