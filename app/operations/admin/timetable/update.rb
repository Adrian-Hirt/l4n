module Operations::Admin::Timetable
  class Update < RailsOps::Operation::Model::Update
    schema3 do
      str! :lan_party_id
      hsh? :timetable do
        str? :start_datetime
        str? :end_datetime
      end
    end

    model ::Timetable

    def find_model
      LanParty.find(osparams.lan_party_id).timetable
    end
  end
end
