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
  end
end
