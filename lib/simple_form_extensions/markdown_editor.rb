module MarkdownEditor
  def markdown(*, **kwargs, &)
    url = kwargs.delete(:preview_url)
    kwargs[:input_html] ||= {}
    kwargs[:input_html][:data] = {
      preview_url: url,
      controller:  'admin--markdown-editor'
    }
    input(*, **kwargs, &)
  end
end

SimpleForm::FormBuilder.include MarkdownEditor
