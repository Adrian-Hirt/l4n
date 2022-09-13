module Operations::Admin::Tournament
  class Index < RailsOps::Operation
    schema3 do
      hsh? :grids_admin_tournaments, additional_properties: true
    end

    policy :on_init do
      authorize! :manage, Tournament
    end

    def grid
      @grid ||= Grids::Admin::Tournaments.new(osparams.grids_admin_tournaments) do |scope|
        scope.page(params[:page])
      end
    end
  end
end
