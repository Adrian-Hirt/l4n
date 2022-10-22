module Operations::Admin::LanParty
  class Index < RailsOps::Operation
    schema3 do
      str? :page
      hsh? :grids_admin_lan_parties, additional_properties: true
    end

    policy :on_init do
      authorize! :manage, LanParty
    end

    def grid
      @grid ||= Grids::Admin::LanParties.new(osparams.grids_admin_lan_parties) do |scope|
        scope.page(params[:page])
      end
    end
  end
end
