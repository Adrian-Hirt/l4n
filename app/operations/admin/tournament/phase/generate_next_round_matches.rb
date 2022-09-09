module Operations::Admin::Tournament::Phase
  class GenerateNextRoundMatches < RailsOps::Operation::Model::Load
    schema3 do
      int! :id, cast_str: true
    end

    model ::Tournament::Phase

    policy do
      fail NoNextRound unless model.next_round

      # Ensure that we can only generate matches for the first round
      # if the status of the phase is "confirmed".
      # Otherwise, ensure that we're in the running status
      if model.next_round.first_round?
        fail WrongStatus unless model.confirmed?
      else
        fail WrongStatus unless model.running?
      end

      # Ensure we can only generate matches for the next round if
      # all matches of the current round are finished
      fail NotAllMatchesFinished unless model.current_round.completed?
    end

    def perform
      ActiveRecord::Base.transaction do
        driver = TournamentDrivers::DefaultDriver.new(model, model.next_round)
        model.generator_class.generate driver

        model.running!
      end
    end
  end

  class NoNextRound < StandardError; end
  class WrongStatus < StandardError; end
  class NotAllMatchesFinished < StandardError; end
end
