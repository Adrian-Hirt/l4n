module Operations::Admin::TimetableEntry
  class Update < RailsOps::Operation::Model::Update
    schema3 do
      int! :id, cast_str: true
      hsh? :timetable_entry do
        str? :title
        str? :link
        str? :timetable_category_id
        str? :entry_start
        str? :entry_end
      end
    end

    model ::TimetableEntry

    def lan_party
      @lan_party ||= model.timetable_category.timetable.lan_party
    end

    def category_candidates
      lan_party.timetable.timetable_categories
    end
  end
end
