module Operations::Admin::TimetableCategory
  class Create < RailsOps::Operation::Model::Create
    schema3 do
      int! :lan_party_id, cast_str: true
      hsh? :timetable_category do
        str? :name
        str? :order
      end
    end

    model ::TimetableCategory

    def perform
      model.timetable = lan_party.timetable
      super
    end

    def lan_party
      @lan_party ||= ::LanParty.find(osparams.lan_party_id)
    end
  end
end
