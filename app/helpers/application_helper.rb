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

  def dark_mode_classes
    'dark' if dark_mode_active?
  end

  def admin_page_title
    breadcrumbs_on_rails.map { |bc| bc.name }.join(' > ')
  end
end
