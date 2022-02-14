module Operations::Admin::LanParty
  class Index < RailsOps::Operation
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
