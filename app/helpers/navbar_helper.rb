module NavbarHelper
  def navbar_item_classes(name, actions: [], excluded_actions: [])
    classes = 'nav-link'

    return classes unless name == controller_name.to_sym
    return classes if actions.any? && !actions.include?(action_name.to_sym)
    return classes if excluded_actions.any? && excluded_actions.include?(action_name.to_sym)

    classes += ' active'

    classes
  end
end
