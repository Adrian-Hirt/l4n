module Operations::Tournament::Team
  class UnregisterFromTournament < RailsOps::Operation::Model::Load
    schema3 do
      int! :id, cast_str: true
    end

    model ::Tournament::Team

    load_model_authorization_action :read_public

    lock_mode :exclusive

    policy do
      # Check that the user is the captain (also works for singleplayer games)
      fail Operations::Exceptions::OpFailed, _('Team|Only the captain can do this') unless model.captain?(context.user)

      # This operation should only be used for multiplayer games
      fail Operations::Exceptions::OpFailed, _('Team|This action is only available for multiplayer games') if model.tournament.singleplayer?

      # Check that the team is not seeded
      fail Operations::Exceptions::OpFailed, _('Tournament|Team|Team is already seeded') if model.seeded?

      # Check that the team is in the correct state
      fail Operations::Exceptions::OpFailed, _('Tournament|Team|Team is not registered for the tournament') unless model.registered?

      # Check that the registration of the tournament is open
      fail Operations::Exceptions::OpFailed, _('Tournament|Registration is closed') unless model.tournament.registration_open?

      # We need to check that there are no phases which are in
      # another state than "created", if yes, we cannot register the
      # team anymore.
      fail Operations::Exceptions::OpFailed, _('Tournament|The tournament has ongoing phases') if model.tournament.ongoing_phases?
    end

    def perform
      model.created!
    end
  end
end
