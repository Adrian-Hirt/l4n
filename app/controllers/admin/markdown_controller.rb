module Admin
  class MarkdownController < AdminController
    def preview
      authorize! :access, :admin_panel
      output = Services::Markdown.render params[:_json]
      render json: output.to_json
    end
  end
end
