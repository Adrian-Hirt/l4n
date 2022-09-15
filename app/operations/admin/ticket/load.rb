module Operations::Admin::Ticket
  class Load < RailsOps::Operation::Model::Load
    schema3 do
      int! :id, cast_str: true
    end

    model ::Ticket
  end
end
