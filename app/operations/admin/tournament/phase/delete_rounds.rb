module Operations::Admin::Tournament::Phase
  class DeleteRounds < RailsOps::Operation::Model::Load
    schema3 do
      int! :id, cast_str: true
    end

    model ::Tournament::Phase

    lock_mode :exclusive

    policy do
      # We can only run this if the phase is in the "seeding" status
      fail Operations::Exceptions::OpFailed, _('Admin|Tournaments|Phase|Phase has wrong status') unless model.seeding?
    end

    def perform
      ActiveRecord::Base.transaction do
        # Delete all rounds
        model.rounds.destroy_all

        # Set all teams to "registered"
        model.phase_teams.each do |phase_team|
          phase_team.team.registered!
        end

        # Remove all seeded teams
        model.phase_teams.destroy_all

        # Set status to `created`
        model.created!
      end
    end
  end
end
