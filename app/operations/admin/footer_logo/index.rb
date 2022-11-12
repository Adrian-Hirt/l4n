module Operations::Admin::FooterLogo
  class Index < RailsOps::Operation
    schema3 do
      str? :page
      hsh? :grids_admin_footer_logos, additional_properties: true
    end

    policy :on_init do
      authorize! :manage, FooterLogo
    end

    def grid
      @grid ||= Grids::Admin::FooterLogos.new(osparams.grids_admin_footer_logos) do |scope|
        scope.page(params[:page])
      end
    end
  end
end
