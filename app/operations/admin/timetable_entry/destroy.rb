module Operations::Admin::TimetableEntry
  class Destroy < RailsOps::Operation::Model::Destroy
    schema3 do
      int! :id, cast_str: true
    end

    model ::TimetableEntry
  end
end
