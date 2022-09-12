module Operations::Tournament::TeamMember
  class Destroy < RailsOps::Operation::Model::Destroy
    schema3 do
      int! :id, cast_str: true
    end

    model ::Tournament::TeamMember

    policy do
      # Check that the team is in "created" state
      fail Operations::Exceptions::OpFailed, _('Team|Cannot leave team') unless model.team.created?

      # Check that the registration of the tournament is open
      fail Operations::Exceptions::OpFailed, _('Tournament|Registration is closed') unless model.team.tournament.registration_open?

      # Check that the user being removed is not the captain (captains cannot leave teams, only delete them).
      fail Operations::Exceptions::OpFailed, _('Team|The captain cannot be removed') if model.captain?

      # Check that the user is the captain OR the user of the membership (users can remove themselfes from teams).
      # This also works for singleplayer games.
      fail Operations::Exceptions::OpFailed, _('Team|Only the captain can do this') unless model.team.captain?(context.user) || model.user_id == context.user.id
    end
  end
end
