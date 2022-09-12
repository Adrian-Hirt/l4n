module Operations::Tournament::Team
  class CreateForTournament < RailsOps::Operation::Model::Create
    schema3 do
      int! :tournament_id, cast_str: true
      hsh? :tournament_team do
        str? :name
      end
    end

    policy do
      # Check that the registration of the tournament is open
      fail Operations::Exceptions::OpFailed, _('Tournament|Registration is closed') unless tournament.registration_open?

      # We need to check that there are no phases which are in
      # another state than "created", if yes, we cannot register the
      # team anymore.
      fail Operations::Exceptions::OpFailed, _('Tournament|The tournament has ongoing phases') if tournament.ongoing_phases?

      fail Operations::Exceptions::OpFailed, _('Tournament|You are already in the tournament') if context.user.teams.where(tournament: tournament).any?
    end

    model ::Tournament::Team

    def perform
      # if it's a singleplayer game that the tournament is played in,
      # we set the name of the team to this users username.
      if tournament.singleplayer?
        model.name = context.user.username
      else
        model.name = osparams.tournament_team[:name]
      end

      # Add the current user as captain
      model.team_members.build(
        user:    context.user,
        captain: true
      )

      model.tournament = tournament
      model.status = Tournament::Team.statuses[:created]
      super
    end

    def tournament
      @tournament ||= ::Tournament.find(osparams.tournament_id)
    end
  end
end
