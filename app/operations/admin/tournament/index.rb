module Operations::Admin::Tournament
  class Index < RailsOps::Operation
    schema3 do
      str? :page
      hsh? :grids_admin_tournaments, additional_properties: true
    end

    policy :on_init do
      authorize! :read, Tournament
    end

    def grid
      @grid ||= Grids::Admin::Tournaments.new(osparams.grids_admin_tournaments) do |scope|
        scope.accessible_by(context.ability).page(params[:page])
      end
    end

    def disputed_match_count
      @disputed_match_count ||= Tournament::Match.accessible_by(context.ability).where(result_status: Tournament::Match.result_statuses[:disputed]).count
    end
  end
end
