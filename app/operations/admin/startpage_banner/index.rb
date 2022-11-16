module Operations::Admin::StartpageBanner
  class Index < RailsOps::Operation
    schema3 do
      str? :page
      hsh? :grids_admin_startpage_banners, additional_properties: true
    end

    policy :on_init do
      authorize! :manage, StartpageBanner
    end

    def grid
      @grid ||= Grids::Admin::StartpageBanners.new(osparams.grids_admin_startpage_banners) do |scope|
        scope.page(params[:page])
      end
    end
  end
end
