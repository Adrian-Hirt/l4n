module ButtonsHelper
  DEFAULT_OPTS = {
    namespace: [],
    size:      nil,
    color:     :primary,
    outline:   false,
    icon_only: false,
    disabled:  false
  }.freeze

  def button(title, href, html: {}, tag: :a, **opts, &)
    options = get_options(opts)
    if opts[:btn_icon]
      button_icon = icon opts[:btn_icon]
      title = (options[:icon_only] ? button_icon : (button_icon + title))
    end
    data = {}
    data = { turbo_method: opts.delete(:method) } if opts[:method]
    if opts.delete(:disable_on_click)
      data[:controller] = 'button'
      data[:action] = 'click->button#disable'
    end
    if opts[:confirm]
      confirm = opts.delete(:confirm)

      if confirm.is_a? String
        data[:confirm] = confirm
      else
        data[:confirm] = _('Buttons|Confirm message')
      end
      data[:controller] = 'button'
      data[:action] = 'click->button#confirmAction'
    end

    tooltip = opts.delete(:tooltip)
    if tooltip
      html[:title] = tooltip
      data['bs-toggle'] = :tooltip
    end

    html[:data] ||= {}
    html[:data].merge!(data)
    _button(title, href, get_btn_class(options), tag: tag, **html, &)
  end

  def show_button(model, html: {}, **opts)
    options = get_options(opts)
    href = options[:href] || polymorphic_path(options[:namespace] << model)
    title = icon %i[fa fa-fw fa-arrow-right]
    title += _('%{name}|Show') % { name: _(model.class.name) } unless options[:icon_only]
    _button(title, href, get_btn_class(options), **html)
  end

  def new_button(klass, html: {}, **opts)
    options = get_options(opts)
    href = options[:href] || new_polymorphic_path(options[:namespace] << klass)
    title = icon %i[fa fa-fw fa-plus]
    title += _('%{name}|New') % { name: _(klass.name) } unless options[:icon_only]
    _button(title, href, get_btn_class(options), **html)
  end

  def edit_button(model, html: {}, **opts)
    options = get_options(opts)
    href = options[:href] || edit_polymorphic_path(options[:namespace] << model)
    title = icon %i[fa fa-fw fa-edit]
    title += _('%{name}|Edit') % { name: _(model.class.name) } unless options[:icon_only]
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
        title += _('%{name}|Delete') % { name: _(model.class.name) }
      end
    end

    if opts[:confirm]
      confirm_message = opts.delete(:confirm)
    else
      confirm_message = _('%{name}|Delete confirmation?') % { name: _(model.class.name) }
    end

    html_options = {
      data:   {
        confirm:    confirm_message,
        controller: 'button',
        action:     'click->button#confirmAction'
      },
      method: :delete
    }.merge!(html)

    html_options[:disabled] = !model.deleteable? if model.respond_to?(:deleteable?)

    _button(title, href, get_btn_class(options), tag: :button, **html_options)
  end

  private

  def _button(title, href, classes, tag: :a, **link_opts, &block)
    # If the button is disabled, replace the link by a '#', such that even inspecting
    # the HTML and enabling the button does not work
    if link_opts[:disabled]
      href = '#'
      link_opts[:method] = nil
      tag = :a
    end

    if tag == :button
      button_to href, class: classes, **link_opts do
        if block
          yield
        else
          title
        end
      end
    else
      link_to href, class: classes, **link_opts do
        if block
          yield
        else
          title
        end
      end
    end
  end

  def get_btn_class(opts)
    classes = %i[btn]
    classes << (opts[:outline] ? "btn-outline-#{opts[:color]}" : "btn-#{opts[:color]}")
    classes << "btn-#{opts[:size]}" if opts[:size]
    classes << 'icon-only-btn' if opts[:icon_only]
    classes << 'disabled' if opts[:disabled]
    classes << opts[:classes] if opts[:classes]
    classes
  end

  def get_options(opts)
    DEFAULT_OPTS.deep_dup.merge(opts)
  end
end
