module Operations::Admin::Tournament::Phase
  class GenerateNextRoundMatches < RailsOps::Operation::Model::Load
    schema3 do
      int! :id, cast_str: true
    end

    model ::Tournament::Phase

    lock_mode :exclusive

    policy do
      fail Operations::Exceptions::OpFailed, _('Admin|Tournaments|Phase|No next round to generate the matches for') unless model.next_round

      # Ensure that we can only generate matches for the first round
      # if the status of the phase is "confirmed".
      # Otherwise, ensure that we're in the running status
      if model.next_round.first_round?
        fail Operations::Exceptions::OpFailed, _('Admin|Tournaments|Phase|Phase has wrong status') unless model.confirmed?
      else
        fail Operations::Exceptions::OpFailed, _('Admin|Tournaments|Phase|Phase has wrong status') unless model.running?

        # Ensure we can only generate matches for the next round if
        # all matches of the current round are finished
        fail Operations::Exceptions::OpFailed, _('Admin|Tournaments|Phase|Please first finish all the matches of the current round') unless model.current_round.completed?
      end
    end

    def perform
      ActiveRecord::Base.transaction do
        # Touch the current round to expire cache
        # rubocop:disable Rails/SkipsModelValidations
        model.current_round&.touch
        # rubocop:enable Rails/SkipsModelValidations

        # Generate new round matches
        driver = TournamentDrivers::DefaultDriver.new(model, model.next_round)
        model.generator_class.generate driver

        model.running!
      end
    end
  end
end
