module Operations::Admin::TimetableCategory
  class Update < RailsOps::Operation::Model::Update
    schema3 do
      int! :id, cast_str: true
      hsh? :timetable_category do
        str? :name
        str? :order
      end
    end

    model ::TimetableCategory

    def lan_party
      @lan_party ||= model.timetable.lan_party
    end
  end
end
