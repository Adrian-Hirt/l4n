module Operations::Tournament::Team
  class Load < RailsOps::Operation::Model::Load
    schema3 do
      int! :id, cast_str: true
    end

    model ::Tournament::Team

    def user_team_membership
      @user_team_membership ||= if model.nil?
                                  nil
                                else
                                  model.team_members.find_by(user: context.user)
                                end
    end

    def grouped_matches
      @grouped_matches ||= begin
        data = Queries::Tournament::Match::FetchForTeamGroupedByPhases.call(team: model)

        sorted_keys = data.keys.sort_by(&:phase_number)

        result = []

        sorted_keys.each do |key|
          result << [key, data[key]]
        end

        result
      end
    end

    # This is a bit hacky, but I did not get rails to format the params in
    # the correct way for js otherwise...
    def seatmap_query
      if model.team_members.none? || model.tournament.lan_party.blank?
        ''
      else
        query_ids = []

        model.team_members.each do |team_member|
          ticket = team_member.user.ticket_for(model.tournament.lan_party)
          next if ticket&.seat.nil?

          query_ids << ticket.seat.id
        end

        return '' if query_ids.none?

        "?highlight=#{query_ids.join('&highlight=')}"
      end
    end
  end
end
