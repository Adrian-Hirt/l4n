module Operations::Admin::Pages
  class Index < RailsOps::Operation
    schema3 do
      str? :page
      hsh? :grids_admin_pages, additional_properties: true
    end

    policy :on_init do
      authorize! :manage, Page
    end

    def grid
      @grid ||= Grids::Admin::Pages.new(osparams.grids_admin_pages) do |scope|
        scope.page(params[:page])
      end
    end
  end
end
