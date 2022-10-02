module Operations::Admin::TimetableEntry
  class Create < RailsOps::Operation::Model::Create
    schema3 do
      int! :lan_party_id, cast_str: true
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
      @lan_party ||= ::LanParty.find(osparams.lan_party_id)
    end

    def category_candidates
      lan_party.timetable.timetable_categories
    end
  end
end
