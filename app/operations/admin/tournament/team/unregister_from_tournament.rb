module Operations::Admin::Tournament::Team
  class UnregisterFromTournament < RailsOps::Operation::Model::Load
    schema3 do
      int! :id, cast_str: true
    end

    model ::Tournament::Team

    policy do
      fail AlreadySeeded if model.seeded?

      fail NotRegistered unless model.registered?

      # We need to check that there are no phases which are in
      # another state than "created", if yes, we cannot register the
      # team anymore.
      fail TournamentHasOngoingPhases if model.tournament.ongoing_phases?
    end

    def perform
      model.created!
    end
  end

  class AlreadySeeded < StandardError; end
  class NotRegistered < StandardError; end
  class TournamentHasOngoingPhases < StandardError; end
end
