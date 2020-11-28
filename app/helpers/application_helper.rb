module ApplicationHelper
  def flash_messages(opts = {})
    flash.each do |msg_type, message|
      concat(content_tag(:div, message, class: "alert alert-#{msg_type} alert-dismissible fade show", role: "alert") do 
              concat content_tag(:button, nil, class: 'btn-close', data: { dismiss: 'alert' })
              concat message 
            end)
    end
    nil
  end
end
