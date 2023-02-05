module Operations::Admin::Tournament::Team
  class RegisterForTournament < RailsOps::Operation::Model::Load
    schema3 do
      int! :id, cast_str: true
    end

    model ::Tournament::Team

    lock_mode :exclusive

    policy do
      fail Operations::Exceptions::OpFailed, _('Admin|Tournament|Team|Team cannot be registered as it has the wrong status') unless model.created?

      # We need to check that there are no phases which are in
      # another state than "created", if yes, we cannot register the
      # team anymore.
      fail Operations::Exceptions::OpFailed, _('Admin|Tournament|The tournament has ongoing phases') if model.tournament.ongoing_phases?

      fail Operations::Exceptions::OpFailed, _('Admin|Tournament|The tournament is full') if model.tournament.teams_full?

      # Check that enough players registered
      fail Operations::Exceptions::OpFailed, _('Admin|Tournament|The team does not have enough players') unless model.full?

      # Check that the team has a captain
      fail Operations::Exceptions::OpFailed, _('Admin|Team|Captain missing') if model.captain_missing?
    end

    def perform
      model.registered!
    end
  end
end
