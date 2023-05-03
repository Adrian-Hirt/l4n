module Operations::Admin::ApiApplication
  class Index < RailsOps::Operation
    schema3 do
      str? :page
      hsh? :grids_admin_api_applications, additional_properties: true
    end

    policy :on_init do
      authorize! :read, ApiApplication
    end

    def grid
      @grid ||= Grids::Admin::ApiApplications.new(osparams.grids_admin_api_applications) do |scope|
        scope.page(params[:page])
      end
    end
  end
end
