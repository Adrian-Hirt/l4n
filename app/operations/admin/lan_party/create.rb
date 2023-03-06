module Operations::Admin::LanParty
  class Create < RailsOps::Operation::Model::Create
    schema3 do
      hsh? :lan_party do
        str! :name
        boo! :active, cast_str: true
        str? :location
        str? :event_start
        str? :event_end
        str? :sort
        boo? :sidebar_active, cast_str: true
        boo? :timetable_enabled, cast_str: true
        boo? :seatmap_enabled, cast_str: true
        boo? :users_may_have_multiple_tickets_assigned, cast_str: true
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
