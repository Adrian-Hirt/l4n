module AdminSidebarHelper
  def active_link_classes(name, actions: [], excluded_actions: [])
    return unless name == controller_name.to_sym
    return if actions.any? && !actions.include?(action_name.to_sym)
    return if excluded_actions.any? && excluded_actions.include?(action_name.to_sym)

    'active'
  end

  def dropdown_header_classes(name)
    return unless name.to_s == controller_name

    'menu-open'
  end

  def dropdown_body_style(name)
    return unless name.to_s == controller_name

    'display: block'
  end
end
