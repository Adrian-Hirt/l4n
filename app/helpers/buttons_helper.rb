module ButtonsHelper
  def button(title, href, color: :primary, size: nil, outline: false, **link_opts)
    classes = get_btn_class(color, outline, size)
    _button(title, href, classes, link_opts)
  end

  def show_button(model, href: nil, namespace: [], color: :primary, size: nil, outline: false, icon_only: false, disabled: false, **link_opts)
    href ||= polymorphic_path(namespace << model)
    classes = get_btn_class(:primary, outline, size, icon_only, disabled)
    title = icon %i[fa fa-arrow-right]
    title += _("#{model.class.name}|Show") unless icon_only
    _button(title, href, classes, link_opts)
  end

  def new_button(klass, href: nil, namespace: [], color: :primary, size: nil, outline: false, icon_only: false, disabled: false, **link_opts)
    href ||= new_polymorphic_path(namespace << klass)
    classes = get_btn_class(:primary, outline, size, icon_only, disabled)
    title = icon %i[fa fa-plus]
    title += _("#{klass.name}|New") unless icon_only
    _button(title, href, classes, link_opts)
  end

  def edit_button(model, href: nil, namespace: [], color: :primary, size: nil, outline: false, icon_only: false, disabled: false, **link_opts)
    href ||= edit_polymorphic_path(namespace << model)
    classes = get_btn_class(:primary, outline, size, icon_only, disabled)
    title = icon %i[fa fa-pencil]
    title += _("#{model.class.name}|Edit") unless icon_only
    _button(title, href, classes, link_opts)
  end

  def delete_button(model, href: nil, namespace: [], color: :primary, size: nil, outline: false, icon_only: false, disabled: false, **link_opts)
    href ||= polymorphic_path(namespace << model)
    classes = get_btn_class(:danger, outline, size, icon_only, disabled)
    title = icon %i[fa fa-trash]
    title += _("#{model.class.name}|Delete") unless icon_only
    options = {
      method: :delete,
      data:   {
        confirm: _("#{model.class.name}|Delete confirmation?")
      }
    }
    link_opts.merge!(options)
    _button(title, href, classes, link_opts)
  end

  private

  def _button(title, href, classes, **link_opts)
    link_to href, class: classes, **link_opts do
      title
    end
  end

  def get_btn_class(color, outline, size, icon_only, disabled)
    classes = %i[btn]
    classes << (outline ? "btn-outline-#{color}" : "btn-#{color}")
    classes << "btn-#{size}" if size
    classes << 'icon-btn' unless icon_only
    classes << 'disabled' if disabled
    classes
  end
end
