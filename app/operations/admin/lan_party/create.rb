module Operations::Admin::LanParty
  class Create < RailsOps::Operation::Model::Create
    schema3 do
      hsh? :lan_party do
        str! :name
        boo! :active, cast_str: true
        str? :location
        str? :event_start
        str? :event_end
      end
    end

    model ::LanParty

    def perform
      model.seat_map = SeatMap.new
      model.timetable = Timetable.new
      super
    end
  end
end
