module Operations::Tournament
  class Load < RailsOps::Operation::Model::Load
    schema3 do
      int! :id, cast_str: true
    end

    model ::Tournament

    def user_team
      @user_team ||= if context.user.nil?
                       nil
                     else

                       context.user.teams.find_by(tournament: model)
                     end
    end

    def user_team_membership
      @user_team_membership ||= if user_team.nil?
                                  nil
                                else
                                  user_team.team_members.find_by(user: context.user)
                                end
    end
  end
end
