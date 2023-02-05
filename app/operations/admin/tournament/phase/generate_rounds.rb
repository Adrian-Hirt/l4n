module Operations::Admin::Tournament::Phase
  class GenerateRounds < RailsOps::Operation::Model::Load
    schema3 do
      int! :id, cast_str: true
      hsh? :phase do
        int? :swiss_rounds, cast_str: true
      end
    end

    model ::Tournament::Phase

    lock_mode :exclusive

    policy do
      # Can't generate the rounds without any teams
      fail Operations::Exceptions::OpFailed, _('Admin|Tournaments|Phase|Cannot generate rounds without any seedable teams') if model.seedable_teams.none?

      # We should only run this once for a phase.
      fail Operations::Exceptions::OpFailed, _('Admin|Tournaments|Phase|Rounds have already been generated') if model.rounds.any?

      # We can only generate rounds if the phase is in the "created" status
      fail Operations::Exceptions::OpFailed, _('Admin|Tournaments|Phase|Phase has wrong status') unless model.created?

      # We cannot do this if the registration is open
      fail Operations::Exceptions::OpFailed, _('Admin|Tournaments|Phase|Please close the registration before generating rounds') if model.tournament.registration_open?

      # We can only do this if the previous round is completed
      fail Operations::Exceptions::OpFailed, _('Admin|Tournaments|Phase|The previous round is still ongoing!') unless model.first_phase? || model.previous_phase.completed?
    end

    def perform
      ActiveRecord::Base.transaction do
        # Create the rounds for the current phase
        number_of_rounds.times do |i|
          model.rounds.create!(
            round_number: i + 1
          )
        end

        # Set the status to "seeding" as now we can seed the teams
        model.seeding!
      end
    end

    private

    def number_of_rounds
      if model.swiss?
        # Take max of calculated rounds and entered rounds
        # if the user entered any value.
        # If the user entered no value, just return the
        # min needed rounds.
        calculated = TournamentSystem::Algorithm::Swiss.minimum_rounds(model.seedable_teams.count(:all))

        if osparams.phase[:swiss_rounds].present?
          [calculated, osparams.phase[:swiss_rounds]].max
        else
          calculated
        end
      # elsif model.round_robin?
      #   TournamentSystem::Algorithm::RoundRobin.total_rounds(model.seedable_teams.count)
      elsif model.single_elimination?
        TournamentSystem::Algorithm::SingleBracket.total_rounds(model.seedable_teams.count)
      elsif model.double_elimination?
        TournamentSystem::Algorithm::DoubleBracket.total_rounds(model.seedable_teams.count)
      else
        fail 'Invalid tournament mode!'
      end
    end
  end
end
