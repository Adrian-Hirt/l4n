module ButtonsHelper
  DEFAULT_OPTS = {
    namespace: [],
    size:      nil,
    color:     :primary,
    outline:   false,
    icon_only: false,
    disabled:  false
  }.freeze

  # rubocop:disable Metrics/ParameterLists
  def button(title, href, html: {}, btn_icon: nil, method: nil, **opts)
    options = get_options(opts)
    if btn_icon
      button_icon = icon btn_icon
      title = (options[:icon_only] ? button_icon : (button_icon + title))
    end
    if method
      html.merge!(
        data: { turbo_method: method }
      )
    end
    _button(title, href, get_btn_class(options), **html)
  end
  # rubocop:enable Metrics/ParameterLists

  def show_button(model, html: {}, **opts)
    options = get_options(opts)
    href = options[:href] || polymorphic_path(options[:namespace] << model)
    title = icon %i[fa fa-fw fa-arrow-right]
    title += _("#{model.class.name}|Show") unless options[:icon_only]
    _button(title, href, get_btn_class(options), **html)
  end

  def new_button(klass, html: {}, **opts)
    options = get_options(opts)
    href = options[:href] || new_polymorphic_path(options[:namespace] << klass)
    title = icon %i[fa fa-fw fa-plus]
    title += _("#{klass.name}|New") unless options[:icon_only]
    _button(title, href, get_btn_class(options), **html)
  end

  def edit_button(model, html: {}, **opts)
    options = get_options(opts)
    href = options[:href] || edit_polymorphic_path(options[:namespace] << model)
    title = icon %i[fa fa-fw fa-edit]
    title += _("#{model.class.name}|Edit") unless options[:icon_only]
    _button(title, href, get_btn_class(options), **html)
  end

  def delete_button(model, html: {}, **opts)
    opts[:color] ||= :danger
    options = get_options(opts)
    href = options[:href] || polymorphic_path(options[:namespace] << model)
    title = icon %i[fa fa-fw fa-trash]
    unless options[:icon_only]
      if options[:title]
        title += options[:title]
      else
        title += _("#{model.class.name}|Delete")
      end
    end
    html_options = {
      data:   {
        confirm: _("#{model.class.name}|Delete confirmation?")
      },
      method: :delete
    }
    html_options.merge!(html)
    button_to href, class: get_btn_class(options), **html_options do
      title
    end
  end

  private

  def _button(title, href, classes, **link_opts)
    link_to href, class: classes, **link_opts do
      title
    end
  end

  def get_btn_class(opts)
    classes = %i[btn]
    classes << (opts[:outline] ? "btn-outline-#{opts[:color]}" : "btn-#{opts[:color]}")
    classes << "btn-#{opts[:size]}" if opts[:size]
    classes << 'icon-only-btn' if opts[:icon_only]
    classes << 'disabled' if opts[:disabled]
    classes
  end

  def get_options(opts)
    DEFAULT_OPTS.deep_dup.merge(opts)
  end
end
