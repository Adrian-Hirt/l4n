module AdminSidebarHelper
  def active_link_classes(name, actions: [], excluded_actions: [])
    return unless name == controller_name.to_sym
    return if actions.any? && !actions.include?(action_name.to_sym)
    return if excluded_actions.any? && excluded_actions.include?(action_name.to_sym)

    'active'
  end

  def sidenav_collapser_classes(name)
    if name.to_s == controller_name
      'active'
    else
      'collapsed'
    end
  end

  def sidenav_collapse_classes(name)
    return unless name.to_s == controller_name

    'show'
  end
end
