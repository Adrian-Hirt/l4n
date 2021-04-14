module Operations::User
  class Load < RailsOps::Operation::Model::Load
    schema3 do
      int! :id, cast_str: true
    end

    model ::User

    # No special auth needed
    without_authorization
  end
end
