module Operations::Tournament::Team
  class UnregisterFromTournament < RailsOps::Operation::Model::Load
    schema3 do
      int! :id, cast_str: true
    end

    model ::Tournament::Team

    policy do
      fail AlreadyAccepted if model.accepted?

      fail NotRegistered unless model.registered?
    end

    def perform
      model.registered!
    end
  end

  class AlreadyAccepted < StandardError; end
  class NotRegistered < StandardError; end
end
