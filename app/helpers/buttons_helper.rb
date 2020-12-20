module ButtonsHelper
  DEFAULT_OPTS = {
    namespace: [],
    size:      nil,
    color:     :primary,
    outline:   false,
    icon_only: false,
    disabled:  false
  }.freeze

  def button(title, href, html: {}, btn_icon: nil, **opts)
    options = get_options(opts)
    if btn_icon
      button_icon = icon btn_icon
      title = (options[:icon_only] ? button_icon : (button_icon + title))
    end
    _button(title, href, get_btn_class(options), **html)
  end

  def show_button(model, html: {}, **opts)
    options = get_options(opts)
    href = options[:href] || polymorphic_path(options[:namespace] << model)
    title = icon %i[fa fa-arrow-right]
    title += _("#{model.class.name}|Show") unless options[:icon_only]
    _button(title, href, get_btn_class(options), **html)
  end

  def new_button(klass, html: {}, **opts)
    options = get_options(opts)
    href = options[:href] || new_polymorphic_path(options[:namespace] << klass)
    title = icon %i[fa fa-plus]
    title += _("#{klass.name}|New") unless options[:icon_only]
    _button(title, href, get_btn_class(options), **html)
  end

  def edit_button(model, html: {}, **opts)
    options = get_options(opts)
    href = options[:href] || edit_polymorphic_path(options[:namespace] << model)
    title = icon %i[fa fa-pencil]
    title += _("#{model.class.name}|Edit") unless options[:icon_only]
    _button(title, href, get_btn_class(options), **html)
  end

  def delete_button(model, html: {}, **opts)
    opts[:color] ||= :danger
    options = get_options(opts)
    href = options[:href] || polymorphic_path(options[:namespace] << model)
    title = icon %i[fa fa-trash]
    title += _("#{model.class.name}|Delete") unless options[:icon_only]
    html_options = {
      method: :delete,
      data:   {
        confirm: _("#{model.class.name}|Delete confirmation?")
      }
    }
    html_options.merge!(html)
    _button(title, href, get_btn_class(options), **html_options)
  end

  private

  def _button(title, href, classes, **link_opts)
    link_to href, class: classes, **link_opts do
      title
    end
  end

  def get_btn_class(**opts)
    classes = %i[btn]
    classes << (opts[:outline] ? "btn-outline-#{opts[:color]}" : "btn-#{opts[:color]}")
    classes << "btn-#{opts[:size]}" if opts[:size]
    classes << 'icon-btn' unless opts[:icon_only]
    classes << 'disabled' if opts[:disabled]
    classes
  end

  def get_options(**opts)
    DEFAULT_OPTS.merge(opts)
  end
end