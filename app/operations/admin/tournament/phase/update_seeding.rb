module Operations::Admin::Tournament::Phase
  class UpdateSeeding < RailsOps::Operation::Model::Load
    schema3 do
      int! :id, cast_str: true
      hsh? :seeding do
        int? :seed, cast_str: true
        int? :team, cast_str: true
      end
    end

    model ::Tournament::Phase

    def perform
      if osparams.seeding[:team].present?
        # Check that the given seed is not taken already
        fail 'Seed already taken' if model.phase_teams.where(seed: osparams.seeding[:seed]).any?

        # Check that the team actually exists
        fail 'Team not found' if team.nil?

        # Check that the team is not seeded already
        fail 'Already seeded' if model.phase_teams.where(team: team).any?

        # Seed the team
        ActiveRecord::Base.transaction do
          ::Tournament::PhaseTeam.create!(
            phase: model,
            team:  team,
            seed:  osparams.seeding[:seed]
          )

          team.seeded! if model.first_phase?
        end
      else
        # Check if there is a team with the given seed, and if yes,
        # un-seed the team
        found_phase_team = model.phase_teams.find_by(seed: osparams.seeding[:seed])

        fail 'No team with that seed found' if found_phase_team.nil?

        # Un-seed the team
        ActiveRecord::Base.transaction do
          team = found_phase_team.team

          found_phase_team.destroy!

          team.registered! if model.first_phase?
        end
      end
    end

    private

    def team
      @team ||= model.seedable_teams.find_by(id: osparams.seeding[:team])
    end
  end
end
