module Operations::User
  class Load < RailsOps::Operation::Model::Load
    schema3 ignore_obsolete_properties: true do
      int! :id, cast_str: true
    end

    model ::User

    # No special auth needed
    without_authorization
  end
end
