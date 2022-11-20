module Operations::Admin::Ticket
  class AssignToUser < RailsOps::Operation::Model::Update
    schema3 do
      int! :id, cast_str: true
      hsh? :assignee do
        str? :username
      end
    end

    model ::Ticket

    def perform
      # Throw exception if the ticket is nil
      fail Operations::Exceptions::OpFailed, _('Ticket|Not found') if model.nil?

      # Throw exception if the ticket already has an user assigned
      fail Operations::Exceptions::OpFailed, _('Ticket|Already assigned') if model.assignee.present?

      # Find the user to assign the ticket to
      user = ::User.find_by('LOWER(username) = ?', osparams.assignee[:username].downcase)

      # Throw exception if the user is nil
      fail Operations::Exceptions::OpFailed, _('Ticket|User not found') if user.nil?

      # Throw exception if the user is not confirmed
      fail Operations::Exceptions::OpFailed, _('Ticket|User not confirmed') unless user.confirmed?

      # Throw exception if the user already has an assigned ticket for
      # the current event
      fail Operations::Exceptions::OpFailed, _('Ticket|User already has assigned ticket') if ::Ticket.where(lan_party: model.lan_party, assignee: user).any?

      # Finally, if all good, assign the ticket
      model.assignee = user
      model.status = Ticket.statuses[:assigned]
      model.save!
    end
  end
end
