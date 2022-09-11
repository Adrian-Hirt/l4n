module Operations::Admin::Tournament::Team
  class RegisterForTournament < RailsOps::Operation::Model::Load
    schema3 do
      int! :id, cast_str: true
    end

    model ::Tournament::Team

    policy do
      fail CannotBeRegistered unless model.created?

      # We need to check that there are no phases which are in
      # another state than "created", if yes, we cannot register the
      # team anymore.
      fail TournamentHasOngoingPhases if model.tournament.ongoing_phases?

      fail TournamentIsFull if model.tournament.teams_full?

      # Check that enough players registered
      fail NotEnoughTeamMembers unless model.full?
    end

    def perform
      model.registered!
    end
  end

  class CannotBeRegistered < StandardError; end
  class TournamentIsFull < StandardError; end
  class TournamentHasOngoingPhases < StandardError; end
  class NotEnoughTeamMembers < StandardError; end
end
