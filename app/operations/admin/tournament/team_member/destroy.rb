module Operations::Admin::Tournament::TeamMember
  class Destroy < RailsOps::Operation::Model::Destroy
    schema3 do
      int! :id, cast_str: true
    end

    model ::Tournament::TeamMember

    policy do
      # Check that the team is in "created" state
      fail WrongState unless model.team.created?
    end
  end

  class WrongState < StandardError; end
end
