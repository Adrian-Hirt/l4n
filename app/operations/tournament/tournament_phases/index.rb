module Operations::Tournament::TournamentPhases
  class Index < RailsOps::Operation
    schema3 do
      int! :tournament_id, cast_str: true
    end

    policy :on_init do
      authorize! :read, tournament
    end

    def tournament
      @tournament ||= ::Tournament.accessible_by(context.ability).find(osparams.tournament_id)
    end

    def phases
      @phases ||= tournament.phases.order(phase_number: :desc).includes(rounds: { matches: %i[away home] })
    end
  end
end
