module Services
  class BootstrapBreadcrumbBuilder < BreadcrumbsOnRails::Breadcrumbs::Builder
    def render
      @elements.collect do |element|
        render_element(element)
      end.join
    end

    def render_element(element)
      classes = %w[breadcrumb-item]

      if element.path.nil? || @context.current_page?(compute_path(element))
        content = compute_name(element)
        classes << 'active'
      else
        content = @context.link_to(compute_name(element), compute_path(element), element.options)
      end

      @context.content_tag(:li, content, class: classes)
    end
  end
end
