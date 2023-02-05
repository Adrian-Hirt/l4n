module Operations::Admin::Tournament::Phase
  class ConfirmSeeding < RailsOps::Operation::Model::Load
    schema3 do
      int! :id, cast_str: true
    end

    model ::Tournament::Phase

    lock_mode :exclusive

    policy :on_init do
      # Check that the phase is in the "seeding" status
      fail WrongStatus unless model.seeding?

      # Check that there are no non-seeded teams
      fail NotAllTeamsSeeded if model.seedable_teams.any?
    end

    def perform
      # Update the status
      model.confirmed!
    end
  end

  class WrongStatus < StandardError; end
  class NotAllTeamsSeeded < StandardError; end
end
