module AdminSidebarHelper
  def active_link_classes(name, actions: [], excluded_actions: [], include_children: false)
    if include_children
      names = controller.class.name.split('::').map(&:downcase)
      return unless names.include?(name.to_s) || name == controller_name.to_sym
    else
      return unless name == controller_name.to_sym
    end

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

  def admin_sidebar_classes
    classes = []
    classes << 'sidebar-collapsed' if cookies['_l4n_admin_sidebar_collapsed'].present?
    classes
  end
end
