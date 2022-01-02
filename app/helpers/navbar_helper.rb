module NavbarHelper
  # TODO: Tidy up this logic a bit
  def menu_item_active_classes(menu_item)
    if MenuItem::PREDEFINED_PAGES.key?(menu_item.page_name)
      navbar_item_active_classes(menu_item.page_name)
    elsif menu_item.is_a? MenuDropdownItem
      return 'active' if menu_item.children.any? { |child| menu_item_active_classes(child) == 'active' }
    elsif menu_item.page_name == request.path.delete('/')
      'active'
    end
  end

  def navbar_item_active_classes(name)
    name.to_s == controller_name ? 'active' : ''
  end
end
