module Operations::Admin::Upload
  class Index < RailsOps::Operation
    schema3 do
      str? :page
      hsh? :grids_admin_uploads, additional_properties: true
    end

    policy :on_init do
      authorize! :read, Upload
    end

    def grid
      @grid ||= Grids::Admin::Uploads.new(osparams.grids_admin_uploads) do |scope|
        scope.page(params[:page])
      end
    end
  end
end
