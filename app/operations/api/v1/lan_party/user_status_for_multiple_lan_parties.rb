module Operations::Api::V1::LanParty
  class UserStatusForMultipleLanParties < RailsOps::Operation
    schema3 do
      obj! :user, classes: [::User], strict: false
    end

    def result
      lan_parties = ::Queries::LanParty::FetchActive.call

      # Iterate over all the lan_parties and build the objects
      # for each lan_party
      lan_parties_data = []

      lan_parties.each do |lan_party|
        # Get data about the lan_party
        lan_party_data = {
          lan_party: {
            id:   lan_party.id,
            name: lan_party.name
          }
        }

        # Get the tickets of the user for the event
        user_tickets = osparams.user.tickets_for(lan_party)

        # If the user has no tickets, the seats object is null
        # and "checked_in" is false. Otherwise, we get seach seat
        # which a ticket might have, and if at least one ticket has
        # the status checked_in, we set "checked_in" to true
        if user_tickets.none?
          lan_party_data[:checked_in] = false
          lan_party_data[:seats] = nil
        else
          checked_in = false

          # Store seats data
          seats_data = []

          user_tickets.each do |ticket|
            # Set checked in flag to true
            checked_in = true if ticket.checked_in?

            # Next iteration if the ticket does not have a seat
            next if ticket.seat.nil?

            seats_data << {
              id:   ticket.seat.id,
              name: ticket.seat.name_or_id.to_s
            }
          end

          lan_party_data[:checked_in] = checked_in
          lan_party_data[:seats] = seats_data
        end

        lan_parties_data << lan_party_data
      end

      # Finally, build the data we return
      {
        user:        {
          id:       osparams.user.id,
          username: osparams.user.username
        },
        lan_parties: lan_parties_data
      }
    end
  end
end
