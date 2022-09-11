module Operations::Admin::Tournament::Team
  class AddUser < RailsOps::Operation::Model::Load
    schema3 do
      int! :id, cast_str: true
      hsh? :team_member do
        str? :name
      end
    end

    model ::Tournament::Team

    policy do
      # Check that we have an user
      fail UserNotFound if user.nil?

      # Check that the user is activated
      fail UserNotActivated unless user.activated?

      # Check that there is still space in the team
      fail TeamIsFull if model.full?

      fail UserInThisTeamAlready if model.users.include?(user)

      # Check that the user is not in another team for this tournament
      fail UserInAnotherTeamAlready if user.teams.where(tournament: model.tournament).any?

      # Check that the user has a ticket (only if the tournament is
      # connected to a lanparty).
      # TODO
    end

    def perform
      model.users << user
    end

    private

    def user
      @user ||= ::User.find_by('LOWER(username) = ?', osparams.team_member[:name].downcase)
    end
  end

  class UserNotFound < StandardError; end
  class UserNotActivated < StandardError; end
  class TeamIsFull < StandardError; end
  class UserInThisTeamAlready < StandardError; end
  class UserInAnotherTeamAlready < StandardError; end
end
