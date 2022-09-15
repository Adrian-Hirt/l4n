module Operations::Tournament::Team
  class Join < RailsOps::Operation::Model::Load
    schema3 do
      int! :id, cast_str: true
      hsh? :join_data do
        str? :password
      end
    end

    policy do
      # Check that the registration of the tournament is open
      fail Operations::Exceptions::OpFailed, _('Tournament|Registration is closed') unless model.tournament.registration_open?

      # We need to check that there are no phases which are in
      # another state than "created", if yes, we cannot register the
      # team anymore.
      fail Operations::Exceptions::OpFailed, _('Tournament|The tournament has ongoing phases') if model.tournament.ongoing_phases?

      # Check that it is not a singleplayer team
      fail Operations::Exceptions::OpFailed, _('Tournament|This is a singleplayer tournament') if model.tournament.singleplayer?

      # Check that there is still space in the team
      fail Operations::Exceptions::OpFailed, _('Team|Team is full') if model.full?

      fail Operations::Exceptions::OpFailed, _('Team|You are in this team already') if model.users.include?(context.user)

      # Check that the user is not in another team for this tournament
      fail Operations::Exceptions::OpFailed, _('Team|You are in another team already') if context.user.teams.where(tournament: model.tournament).any?

      # Check that the user has a ticket (only if the tournament is
      # connected to a lanparty).
      # rubocop:disable Style/SoleNestedConditional
      if model.tournament.lan_party.present?
        fail Operations::Exceptions::OpFailed, _('Tournament|You need to be checked in to do this') if context.user.ticket_for(model.tournament.lan_party).nil? || !context.user.ticket_for(model.tournament.lan_party).checked_in?
      end
      # rubocop:enable Style/SoleNestedConditional
    end

    model ::Tournament::Team

    def perform
      fail Operations::Exceptions::OpFailed, _('Team|Password is incorrect') unless model.authenticate(osparams.join_data[:password])

      model.users << context.user
    end
  end
end
