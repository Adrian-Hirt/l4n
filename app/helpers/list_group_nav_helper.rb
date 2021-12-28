module ListGroupNavHelper
  def nav_item_classes(controller: nil, actions: [], excluded_actions: [])
    classes = 'list-group-item list-group-item-action'

    return classes if controller.present? && controller != controller_path
    return classes if actions.any? && actions.exclude?(action_name.to_sym)
    return classes if excluded_actions.any? && excluded_actions.include?(action_name.to_sym)

    classes += ' active'

    classes
  end
end
