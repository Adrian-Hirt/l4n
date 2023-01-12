module Operations::Event
  class Load < RailsOps::Operation::Model::Load
    schema3 ignore_obsolete_properties: true do
      int! :id, cast_str: true
    end

    model ::Event
  end
end
