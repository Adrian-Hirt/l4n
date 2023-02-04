module NavbarHelper
  def menu_item_active_classes(menu_item)
    if menu_item.lan_party_id.present?
      return 'active' if ("lan/#{menu_item.static_page_name}" == controller_path && params[:id] == menu_item.lan_party_id.to_s)
    elsif menu_item.static_page_name.present?
      navbar_item_active_classes(menu_item.static_page_name, use_namespace: menu_item.use_namespace_for_active_detection)
    elsif menu_item.is_a? MenuDropdownItem
      return 'active' if menu_item.children.any? { |child| menu_item_active_classes(child) == 'active' }
    elsif menu_item.page&.url == request.path.delete('/')
      'active'
    end
  end

  def navbar_item_active_classes(name, use_namespace: false)
    if use_namespace
      controller_path.starts_with?(name.to_s) ? 'active' : ''
    else
      name.to_s == controller_path ? 'active' : ''
    end
  end
end
