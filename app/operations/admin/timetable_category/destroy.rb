module Operations::Admin::TimetableCategory
  class Destroy < RailsOps::Operation::Model::Destroy
    schema3 do
      int! :id, cast_str: true
    end

    model ::TimetableCategory
  end
end
