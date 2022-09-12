module Operations::Tournament::Team
  class RegisterForTournament < RailsOps::Operation::Model::Load
    schema3 do
      int! :id, cast_str: true
    end

    model ::Tournament::Team

    policy do
      # Check that the user is the captain (also works for singleplayer games)
      fail Operations::Exceptions::OpFailed, _('Team|Only the captain can do this') unless model.captain?(context.user)

      # Check that the team has the correct status
      fail Operations::Exceptions::OpFailed, _('Tournament|Team|Team cannot be registered as it has the wrong status') unless model.created?

      # Check that the registration of the tournament is open
      fail Operations::Exceptions::OpFailed, _('Tournament|Registration is closed') unless model.tournament.registration_open?

      # We need to check that there are no phases which are in
      # another state than "created", if yes, we cannot register the
      # team anymore.
      fail Operations::Exceptions::OpFailed, _('Tournament|The tournament has ongoing phases') if model.tournament.ongoing_phases?

      fail Operations::Exceptions::OpFailed, _('Tournament|The tournament is full') if model.tournament.teams_full?

      # Check that enough players registered
      fail Operations::Exceptions::OpFailed, _('Tournament|The team does not have enough players') unless model.full?
    end

    def perform
      model.registered!
    end
  end

  class AlreadyRegistered < StandardError; end
end
