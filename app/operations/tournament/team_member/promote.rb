module Operations::Tournament::TeamMember
  class Promote < RailsOps::Operation::Model::Update
    schema3 do
      int! :id, cast_str: true
    end

    model ::Tournament::TeamMember

    load_model_authorization_action nil

    policy do
      # Check that the user is the captain (also works for singleplayer games)
      fail Operations::Exceptions::OpFailed, _('Team|Only the captain can do this') unless model.team.captain?(context.user)

      # Check that the team is not seeded
      fail Operations::Exceptions::OpFailed, _('Tournament|Team|Team is already seeded') if model.team.seeded?

      tournament = model.team.tournament

      # Check that the registration of the tournament is open
      fail Operations::Exceptions::OpFailed, _('Tournament|Registration is closed') unless tournament.registration_open?

      # We need to check that there are no phases which are in
      # another state than "created", if yes, we cannot register the
      # team anymore.
      fail Operations::Exceptions::OpFailed, _('Tournament|The tournament has ongoing phases') if tournament.ongoing_phases?

      # Check that the user has a ticket (only if the tournament is
      # connected to a lanparty).
      # rubocop:disable Style/SoleNestedConditional
      if tournament.lan_party.present?
        fail Operations::Exceptions::OpFailed, _('Tournament|You need to be checked in to do this') if context.user.ticket_for(tournament.lan_party).nil? || !context.user.ticket_for(tournament.lan_party).checked_in?
      end
      # rubocop:enable Style/SoleNestedConditional
    end

    def perform
      # Don't need to do anything if the current team_member is already captain
      return if model.captain?

      # Remove the captain role from the existing captain
      previous_captain = model.team.team_members.find_by(captain: true)
      if previous_captain.present?
        previous_captain.captain = false
        previous_captain.save!
      end

      # Add the captain role to the new captain
      model.captain = true
      model.save!
    end
  end
end
