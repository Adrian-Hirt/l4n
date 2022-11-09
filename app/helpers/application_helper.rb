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

  def dark_mode_active?
    current_user&.use_dark_mode || cookies[:_l4n_dark_mode].present?
  end

  def dark_mode_classes
    'dark' if dark_mode_active?
  end

  def admin_page_title
    breadcrumbs_on_rails.map(&:name).join(' > ')
  end

  def page_title
    titles = [L4n::Application.config.application_name]
    titles += breadcrumbs_on_rails.drop(1).map(&:name)
    titles.join(' > ')
  end

  def lan_party_progress_bar(lan_party)
    render partial: 'shared/lan_party_progress_bar', locals: { lan_party: lan_party }
  end
end
