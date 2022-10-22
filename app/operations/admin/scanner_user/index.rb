module Operations::Admin::ScannerUser
  class Index < RailsOps::Operation
    schema3 do
      str? :page
      hsh? :grids_admin_scanner_users, additional_properties: true
    end

    policy :on_init do
      authorize! :manage, ScannerUser
    end

    def grid
      @grid ||= Grids::Admin::ScannerUsers.new(osparams.grids_admin_scanner_users) do |scope|
        scope.page(params[:page])
      end
    end
  end
end
