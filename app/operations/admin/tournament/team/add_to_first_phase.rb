module Operations::Admin::Tournament::Team
  class AddToFirstPhase < RailsOps::Operation
    schema3 do
      int! :tournament_id, cast_str: true
      int! :team_id, cast_str: true
      int! :seed
    end

    def perform
      ActiveRecord::Base.transaction do
        ::Tournament::PhaseTeam.create!(
          tournament_phase: phase,
          tournament_team:  team,
          seed:             osparams.seed
        )

        team.seeded!
      end
    end

    private

    def tournament
      @tournament ||= ::Tournament.find(osparams.tournament_id)
    end

    def phase
      @phase ||= tournament.phases.order(:phase_number).first
    end

    def team
      @team ||= tournament.teams.find(osparams.team_id)
    end
  end
end
