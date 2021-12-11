module ApplicationHelper
  def flash_messages(_opts = {})
    flash.each do |msg_type, message|
      concat(content_tag(:div, message, class: "alert alert-#{msg_type} alert-dismissible fade show notification-flash", role: 'alert') do
               concat content_tag(:button, nil, class: 'btn-close', data: { 'bs-dismiss': 'alert' })
               concat message
             end)
    end
    nil
  end

  def active_locale_class(locale)
    if FastGettext.locale == locale.to_s
      ' active'
    else
      ''
    end
  end

  def dark_mode_active?
    current_user&.use_dark_mode || cookies[:_l4n_dark_mode].present?
  end

  def body_classes
    'dark-mode' if dark_mode_active?
  end

  def header_classes
    if dark_mode_active?
      'navbar-dark'
    else
      'navbar-light navbar-white'
    end
  end
end
