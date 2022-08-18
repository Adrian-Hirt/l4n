module Operations::Admin::Tournament::Phase
  class GenerateNextRoundMatches < RailsOps::Operation::Model::Load
    schema3 do
      int! :id
    end

    model ::Tournament::Phase

    policy do
      fail NoNextRound unless next_round
    end

    def perform
      driver = TournamentDrivers::DefaultDriver.new(model, next_round)
      model.generator_class.generate driver
    end

    private

    def next_round
      @next_round ||= model.rounds.order(:round_number).find { |r| r.matches.none? }
    end
  end

  class NoNextRound < StandardError; end
end
