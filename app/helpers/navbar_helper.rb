module NavbarHelper
  def visible?(menu_item)
    if MenuItem::PREDEFINED_PAGES.keys.include?(menu_item.page_name)
      can?(:read, MenuItem::PREDEFINED_PAGES[menu_item.page_name]) && menu_item.visible?
    else
      menu_item.visible?
    end
  end

  # Todo: Tidy up this logic a bit
  def menu_item_active_classes(menu_item)
    if MenuItem::PREDEFINED_PAGES.keys.include?(menu_item.page_name)
      return navbar_item_active_classes(menu_item.page_name)
    elsif menu_item.children.any?
      return 'active' if menu_item.children.any? { |child| menu_item_active_classes(child) == 'active' }
    else
      return 'active' if menu_item.page_name == request.path.gsub('/', '')
    end
  end

  def navbar_item_active_classes(name)
    name.to_s == controller_name ? 'active' : ''
  end
end
