module Operations::Admin::Tournament::Team
  class UnregisterFromTournament < RailsOps::Operation::Model::Load
    schema3 do
      int! :id, cast_str: true
    end

    model ::Tournament::Team

    policy do
      fail AlreadySeeded if model.seeded?

      fail NotRegistered unless model.registered?
    end

    def perform
      model.created!
    end
  end

  class AlreadySeeded < StandardError; end
  class NotRegistered < StandardError; end
end
