module Operations::Admin::Tournament::Team
  class UnregisterFromTournament < RailsOps::Operation::Model::Load
    schema3 do
      int! :id, cast_str: true
    end

    model ::Tournament::Team

    lock_mode :exclusive

    policy do
      # This operation should only be used for multiplayer games
      fail Operations::Exceptions::OpFailed, _('Admin|Team|This action is only available for multiplayer games') if model.tournament.singleplayer?

      fail Operations::Exceptions::OpFailed, _('Admin|Tournament|Team|Team is already seeded') if model.seeded?

      fail Operations::Exceptions::OpFailed, _('Admin|Tournament|Team|Team is not registered for the tournament') unless model.registered?

      # We need to check that there are no phases which are in
      # another state than "created", if yes, we cannot register the
      # team anymore.
      fail Operations::Exceptions::OpFailed, _('Admin|Tournament|The tournament has ongoing phases') if model.tournament.ongoing_phases?
    end

    def perform
      model.created!
    end
  end
end
