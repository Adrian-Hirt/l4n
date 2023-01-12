module Operations::Admin::Page
  class Index < RailsOps::Operation
    schema3 do
      str? :content_page
      str? :redirect_page
      hsh? :grids_admin_content_pages, additional_properties: true
      hsh? :grids_admin_redirect_pages, additional_properties: true
    end

    policy :on_init do
      authorize! :manage, Page
    end

    def content_page_grid
      @content_page_grid ||= Grids::Admin::ContentPages.new(osparams.grids_admin_content_pages) do |scope|
        scope.page(params[:content_page])
      end
    end

    def redirect_page_grid
      @redirect_page_grid ||= Grids::Admin::RedirectPages.new(osparams.grids_admin_redirect_pages) do |scope|
        scope.page(params[:redirect_page])
      end
    end
  end
end
