module AdminSidebarHelper
  def active_classes(name)

    return unless name.to_s == controller_name

    'active'
  end
end