module Operations::Admin::LanParty
  class Create < RailsOps::Operation::Model::Create
    schema3 do
      hsh? :lan_party do
        str! :name
        boo! :active, cast_str: true
      end
    end

    model ::LanParty

    def perform
      model.seat_map = SeatMap.new
      super
    end
  end
end
