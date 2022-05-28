module Operations::Admin::SeatCategory
  class Create < RailsOps::Operation::Model::Create
    schema3 do
      int! :lan_party_id, cast_str: true
      hsh? :seat_category do
        str! :name
        str! :color
      end
    end

    model ::SeatCategory

    def perform
      model.lan_party = lan_party
      super
    end

    def lan_party
      @lan_party ||= LanParty.find(osparams.lan_party_id)
    end
  end
end
