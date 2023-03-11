module Operations::Api::V1::LanParty
  class UserStatusForIndividualLanParty < RailsOps::Operation
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

      # Next, we need to check if the current user has at
      # least one ticket for the LanParty
      user_tickets = osparams.user.tickets_for(lan_party)

      # Fail with an exception if the user has no ticket
      fail Operations::Api::V1::LanParty::UserHasNoTicket if user_tickets.none?

      # Next, check if the status of at least one ticket is checked in,
      # otherwise fail as well
      fail Operations::Api::V1::LanParty::NotCheckedIn unless user_tickets.any?(&:checked_in?)

      # Store seats data
      seats_data = []

      user_tickets.each do |ticket|
        # Next iteration if the ticket does not have a seat
        next if ticket.seat.nil?

        seats_data << {
          id:   ticket.seat.id,
          name: ticket.seat.name_or_id.to_s
        }
      end

      {
        user:  {
          id:       osparams.user.id,
          username: osparams.user.username
        },
        seats: seats_data
      }
    end
  end

  class LanNotFoundOrNotActive < StandardError; end
  class UserHasNoTicket < StandardError; end
  class NotCheckedIn < StandardError; end
end
