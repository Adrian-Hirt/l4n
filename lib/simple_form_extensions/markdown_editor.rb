module MarkdownEditor
  def markdown(*args, **kwargs, &)
    url = kwargs.delete(:preview_url)
    kwargs[:input_html] ||= {}
    kwargs[:input_html][:data] = {
      preview_url: url,
      controller:  'admin--markdown-editor'
    }
    input(*args, **kwargs, &)
  end
end

SimpleForm::FormBuilder.include MarkdownEditor
