module AdminLayoutHelper
  def admin_body_classes
    classes = []
    classes << 'sidebar-collapse' if cookies['_l4n_admin_sidebar_collapsed'].present?
    # rubocop:disable Lint/LiteralAsCondition
    classes << 'dark-mode' if false
    # rubocop:enable Lint/LiteralAsCondition
    classes
  end
end
