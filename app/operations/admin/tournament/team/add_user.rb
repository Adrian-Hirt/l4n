module Operations::Admin::Tournament::Team
  class AddUser < RailsOps::Operation::Model::Load
    schema3 do
      int! :id, cast_str: true
      hsh? :team_member do
        str? :name
      end
    end

    model ::Tournament::Team

    lock_mode :exclusive

    policy do
      # Check that we have an user
      fail Operations::Exceptions::OpFailed, _('Admin|Team|User not found') if user.nil?

      # Check that the user is confirmed
      fail Operations::Exceptions::OpFailed, _('Admin|Team|User not confirmed') unless user.confirmed?

      # Check that there is still space in the team
      fail Operations::Exceptions::OpFailed, _('Admin|Team|Team is full') if model.full?

      fail Operations::Exceptions::OpFailed, _('Admin|Team|User is in this team already') if model.users.include?(user)

      # Check that the user is not in another team for this tournament
      fail Operations::Exceptions::OpFailed, _('Admin|Team|User is in another team already') if user.teams.where(tournament: model.tournament).any?

      # Check that the user has a ticket (only if the tournament is
      # connected to a lanparty).
      # rubocop:disable Style/SoleNestedConditional
      if model.tournament.lan_party.present?
        fail Operations::Exceptions::OpFailed, _('Admin|Team|User needs to be checked in to do this') if user.ticket_for(model.tournament.lan_party).nil? || !user.ticket_for(model.tournament.lan_party).checked_in?
      end
      # rubocop:enable Style/SoleNestedConditional
    end

    def perform
      # If there are users in the team already, we simply add the user. If there are no
      # users yet, we set the newly added user to be the teamcaptain
      if model.team_members.any?
        model.users << user
      else
        model.team_members.create!(
          user:    user,
          captain: true
        )
      end
    end

    private

    def user
      @user ||= ::User.find_by('LOWER(username) = ?', osparams.team_member[:name].downcase)
    end
  end
end
