module MarkdownHelper
  def markdown(text)
    tag.div class: 'markdown-rendering' do
      Services::Markdown.render(text)
    end
  end
end
