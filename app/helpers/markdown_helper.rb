module MarkdownHelper
  def markdown(text)
    Services::Markdown.render(text)
  end
end
