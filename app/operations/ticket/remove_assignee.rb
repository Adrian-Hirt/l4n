module Operations::Ticket
  class RemoveAssignee < RailsOps::Operation::Model::Load
    schema3 do
      int! :id, cast_str: true
    end

    model ::Ticket

    attr_accessor :result

    load_model_authorization_action :use

    def perform
      model.assignee = nil
      model.save!
    end
  end
end
