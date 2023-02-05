module Operations::Admin::Tournament::Phase
  class ResetSeedingConfirmation < RailsOps::Operation::Model::Load
    schema3 do
      int! :id, cast_str: true
    end

    model ::Tournament::Phase

    lock_mode :exclusive

    policy :on_init do
      # Check that the phase is in the "confirmed" status
      fail WrongStatus unless model.confirmed?
    end

    def perform
      # Update the status
      model.seeding!
    end
  end

  class WrongStatus < StandardError; end
  class NotAllTeamsSeeded < StandardError; end
end
