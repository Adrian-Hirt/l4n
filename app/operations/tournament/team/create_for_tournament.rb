module Operations::Tournament::Team
  class CreateForTournament < RailsOps::Operation::Model::Create
    schema3 do
      int! :tournament_id, cast_str: true
      hsh? :tournament_team do
        str? :name
        str? :password
        str? :tournament_team_rank_id
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

      # If the tournament is already full and a singleplayer tournament,
      # throw an error
      fail Operations::Exceptions::OpFailed, _('Tournament|The tournament is full') if tournament.singleplayer? && tournament.teams_full?

      # If the tournament is linked to a lan_party, the current_user needs to have a ticket
      # in "checked_in" status to create a team.
      # rubocop:disable Style/SoleNestedConditional
      if tournament.lan_party.present?
        fail Operations::Exceptions::OpFailed, _('Tournament|You need to be checked in to do this') if context.user.ticket_for(tournament.lan_party).nil? || !context.user.ticket_for(tournament.lan_party).checked_in?
      end
      # rubocop:enable Style/SoleNestedConditional
    end

    model ::Tournament::Team

    def perform
      # if it's a singleplayer game that the tournament is played in,
      # we set the name of the team to this users username, and directly
      # join the tournament, as the two-step process is only needed for
      # teams with multiple players.
      if tournament.singleplayer?
        model.name = context.user.username
        model.status = Tournament::Team.statuses[:registered]
      else
        model.name = osparams.tournament_team[:name]
        model.status = Tournament::Team.statuses[:created]
      end

      # Add the current user as captain
      model.team_members.build(
        user:    context.user,
        captain: true
      )

      model.tournament = tournament
      super
    end

    def tournament
      @tournament ||= ::Tournament.find(osparams.tournament_id)
    end
  end
end
