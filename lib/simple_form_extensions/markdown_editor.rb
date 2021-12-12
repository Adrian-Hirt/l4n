module MarkdownEditor
  def markdown(*args, **kwargs, &block)
    url = kwargs.delete(:preview_url)
    kwargs[:input_html] ||= {}
    kwargs[:input_html].merge!({
                                 data: {
                                   preview_url: url,
                                   controller:  'admin--markdown-editor'
                                 }
                               })
    input(*args, **kwargs, &block)
  end
end

SimpleForm::FormBuilder.include MarkdownEditor
