module Operations::Tournament::Team
  class Index < RailsOps::Operation
    schema3 do
      int! :tournament_id, cast_str: true
    end

    policy :on_init do
      authorize! :read_public, Tournament
    end

    def teams
      @teams ||= tournament.teams.order(:name)
    end

    def tournament
      @tournament ||= ::Tournament.accessible_by(context.ability, :read_public).find(osparams.tournament_id)
    end

    def user_team
      @user_team ||= if context.user.nil?
                       nil
                     else
                       context.user.teams.find_by(tournament: tournament)
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
