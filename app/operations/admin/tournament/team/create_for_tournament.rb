module Operations::Admin::Tournament::Team
  class CreateForTournament < RailsOps::Operation::Model::Create
    schema3 do
      int! :tournament_id, cast_str: true
      hsh? :tournament_team do
        str? :name
        str? :password
        str? :single_user_name
      end
    end

    policy do
      # We need to check that there are no phases which are in
      # another state than "created", if yes, we cannot register the
      # team anymore.
      fail Operations::Exceptions::OpFailed, _('Admin|Tournaments|Team|No new teams can be created') if tournament.ongoing_phases?

      # If we're playing a singleplayer game, we need the user to be
      # present, otherwise it won't work.
      if tournament.singleplayer?
        if singleplayer_user.nil?
          model.errors.add(:single_user_name, _('Team|User cannot be found'))
          fail UserError
        elsif !singleplayer_user.activated?
          model.errors.add(:single_user_name, _('Team|User is not activated'))
          fail UserError
        elsif singleplayer_user.teams.where(tournament: tournament).any?
          model.errors.add(:single_user_name, _('Team|User is already in tournament'))
          fail UserError
        end

        # Check that the user has a ticket (only if the tournament is
        # connected to a lanparty).
        # rubocop:disable Style/SoleNestedConditional
        if tournament.lan_party.present?
          fail Operations::Exceptions::OpFailed, _('Admin|Team|User needs to be checked in to do this') if singleplayer_user.ticket_for(tournament.lan_party).nil? || !singleplayer_user.ticket_for(tournament.lan_party).checked_in?
        end
        # rubocop:enable Style/SoleNestedConditional
      end
    end

    model ::Tournament::Team do
      attribute :single_user_name
    end

    def perform
      # if it's a singleplayer game that the tournament is played in,
      # we add the user (identifier by the name) as a captain and set
      # the name of the team to this users username.
      if tournament.singleplayer?
        model.team_members.build(
          user:    singleplayer_user,
          captain: true
        )

        model.name = singleplayer_user.username
      end

      model.tournament = tournament
      model.status = Tournament::Team.statuses[:created]
      super
    end

    def tournament
      @tournament ||= ::Tournament.find(osparams.tournament_id)
    end

    private

    def singleplayer_user
      @singleplayer_user ||= ::User.find_by('LOWER(username) = ?', osparams.tournament_team[:single_user_name].downcase)
    end
  end

  class TournamentHasOngoingPhases < StandardError; end
  class UserError < StandardError; end
end
