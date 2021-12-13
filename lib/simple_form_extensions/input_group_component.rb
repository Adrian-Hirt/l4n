module InputGroup
  def prepend(_wrapper_options = nil)
    options[:prepend_options] ||= {}
    template.content_tag(:div, options[:prepend], class: 'input-group-text', **options[:prepend_options])
  end

  def append(_wrapper_options = nil)
    options[:append_options] ||= {}
    template.content_tag(:div, options[:append], class: 'input-group-text', **options[:append_options])
  end
end

# Register the component in Simple Form.
SimpleForm.include_component(InputGroup)
