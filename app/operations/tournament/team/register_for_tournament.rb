module Operations::Tournament::Team
  class RegisterForTournament < RailsOps::Operation::Model::Load
    schema3 do
      int! :id, cast_str: true
      int! :tournament_id, cast_str: true
    end

    model ::Tournament::Team

    policy do
      fail AlreadyRegistered if tournament.teams.include?(model)

      # TODO: check that enough players registered
    end

    def perform
      model.registered!
    end

    private

    def tournament
      @tournament ||= ::Tournament.find(osparams.tournament_id)
    end
  end

  class AlreadyRegistered < StandardError; end
end
