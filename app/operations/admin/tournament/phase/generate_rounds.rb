module Operations::Admin::Tournament::Phase
  class GenerateRounds < RailsOps::Operation::Model::Load
    schema3 do
      int! :id
      int? :swiss_rounds, cast_str: true
    end

    model ::Tournament::Phase

    policy do
      # Can't generate the rounds without any teams
      fail NoTeamsPresent if model.teams.none?

      # We should only run this once for a round.
      fail RoundsAlreadyGenerated if model.rounds.any?
    end

    def perform
      # Create the rounds for the current phase
      number_of_rounds.times do |i|
        model.rounds.create!(
          round_number: i + 1
        )
      end
    end

    private

    def number_of_rounds
      if model.swiss?
        # Take max of calculated rounds and entered rounds
        # if the user entered any value.
        # If the user entered no value, just return the
        # min needed rounds.
        calculated = TournamentSystem::Algorithm::Swiss.minimum_rounds(model.teams.count)

        if osparams.swiss_rounds.present?
          [calculated, osparams.swiss_rounds].max
        else
          calculated
        end
      elsif model.round_robin?
        TournamentSystem::Algorithm::RoundRobin.total_rounds(model.teams.count)
      elsif model.single_elimination?
        TournamentSystem::Algorithm::SingleBracket.total_rounds(model.teams.count)
      elsif model.double_elimination?
        TournamentSystem::Algorithm::DoubleBracket.total_rounds(model.teams.count)
      else
        fail 'Invalid tournament mode!'
      end
    end
  end

  class NoTeamsPresent < StandardError; end
  class RoundsAlreadyGenerated < StandardError; end
end
