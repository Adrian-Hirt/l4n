module Operations::Tournament::TeamMember
  class Destroy < RailsOps::Operation::Model::Destroy
    schema3 do
      int! :id, cast_str: true
    end

    model ::Tournament::TeamMember

    load_model_authorization_action nil

    policy do
      # Check that the team is in "created" state
      fail Operations::Exceptions::OpFailed, _('Team|Cannot leave team') unless model.team.created?

      tournament = model.team.tournament

      # Check that the registration of the tournament is open
      fail Operations::Exceptions::OpFailed, _('Tournament|Registration is closed') unless tournament.registration_open?

      # Check that the user being removed is not the captain (captains cannot leave teams, only delete them).
      fail Operations::Exceptions::OpFailed, _('Team|The captain cannot be removed') if model.captain?

      # Check that the user is the captain OR the user of the membership (users can remove themselfes from teams).
      # This also works for singleplayer games.
      fail Operations::Exceptions::OpFailed, _('Team|Only the captain can do this') unless model.team.captain?(context.user) || model.user_id == context.user.id

      # Check that the user has a ticket (only if the tournament is
      # connected to a lanparty).
      # rubocop:disable Style/SoleNestedConditional
      if tournament.lan_party.present?
        fail Operations::Exceptions::OpFailed, _('Tournament|You need to be checked in to do this') if context.user.ticket_for(tournament.lan_party).nil? || !context.user.ticket_for(tournament.lan_party).checked_in?
      end
      # rubocop:enable Style/SoleNestedConditional
    end
  end
end
