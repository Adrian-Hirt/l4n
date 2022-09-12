module Operations::Tournament::Team
  class Update < RailsOps::Operation::Model::Update
    schema3 do
      int! :id, cast_str: true
      hsh? :tournament_team do
        str? :name
        str? :password
      end
    end

    model ::Tournament::Team

    policy do
      # Check that the user is the captain (also works for singleplayer games)
      fail Operations::Exceptions::OpFailed, _('Team|Only the captain can do this') unless model.captain?(context.user)

      # Check that the team is not seeded
      fail Operations::Exceptions::OpFailed, _('Tournament|Team|Team is already seeded') if model.seeded?

      # Check that the team is in the correct state
      fail Operations::Exceptions::OpFailed, _('Tournament|Team|Team is not registered for the tournament') unless model.registered?
    end
  end
end
