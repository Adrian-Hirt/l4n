module Admin
  class MarkdownController < AdminController
    def preview
      authorize! :access, :admin_panel
      output = view_context.tag.div(class: 'markdown-rendering') { Services::Markdown.render params[:_json] }
      render json: output.to_json
    end
  end
end
