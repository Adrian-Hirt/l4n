module Operations::Api::V1::LanParty
  class Me < RailsOps::Operation
    schema3 do
      int! :id, cast_str: true
      obj! :user, classes: [::User], strict: false
    end

    def result
      # First, check if we have a LanParty with the given ID
      lan_party = ::LanParty.find_by(id: osparams.id)

      fail Operations::Api::V1::LanParty::LanNotFoundOrNotActive if lan_party.nil?

      # Next, check if the found LanParty is active. If not, we
      # also return the same exception as before
      fail Operations::Api::V1::LanParty::LanNotFoundOrNotActive unless lan_party.active?

      # Next, we need to check if the current user has a
      # ticket for the LanParty
      user_ticket = osparams.user.ticket_for(lan_party)

      # Fail with an exception if the user has no ticket
      fail Operations::Api::V1::LanParty::UserHasNoTicket if user_ticket.nil?

      # Next, check if the status of the ticket is checked in,
      # otherwise fail as well
      fail Operations::Api::V1::LanParty::NotCheckedIn unless user_ticket.checked_in?

      # Finally, we're all set to return the data. For that, we also need
      # to get the seat assigned to the ticket
      seat = user_ticket.seat

      {
        user: {
          id:       osparams.user.id,
          username: osparams.user.username
        },
        seat: {
          id:   seat.id,
          name: seat.name_or_id.to_s
        }
      }
    end
  end

  class LanNotFoundOrNotActive < StandardError; end
  class UserHasNoTicket < StandardError; end
  class NotCheckedIn < StandardError; end
end
