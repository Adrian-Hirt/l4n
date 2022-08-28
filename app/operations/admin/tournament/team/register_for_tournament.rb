module Operations::Admin::Tournament::Team
  class RegisterForTournament < RailsOps::Operation::Model::Load
    schema3 do
      int! :id, cast_str: true
    end

    model ::Tournament::Team

    policy do
      fail AlreadyRegistered if model.registered?

      # TODO: check that enough players registered
    end

    def perform
      model.registered!
    end
  end

  class AlreadyRegistered < StandardError; end
end
