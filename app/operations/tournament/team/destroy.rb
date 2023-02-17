module Operations::Tournament::Team
  class Destroy < RailsOps::Operation::Model::Destroy
    schema3 do
      int! :id, cast_str: true
    end

    load_model_authorization_action :read_public

    model ::Tournament::Team

    policy do
      # Check that the team is deletable
      fail Operations::Exceptions::OpFailed, _('Team|Not deletable') unless model.deleteable?

      # Check that the registration of the tournament is open
      fail Operations::Exceptions::OpFailed, _('Tournament|Registration is closed') unless model.tournament.registration_open?

      # Check that the user is the captain (also works for singleplayer games)
      fail Operations::Exceptions::OpFailed, _('Team|Only the captain can do this') unless model.captain?(context.user)
    end
  end
end
