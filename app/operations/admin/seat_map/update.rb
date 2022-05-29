module Operations::Admin::SeatMap
  class Update < RailsOps::Operation::Model::Update
    schema3 do
      str! :lan_party_id
      hsh? :seat_map do
        int? :background_height, cast_str: true
        int? :background_width, cast_str: true
        int? :canvas_height, cast_str: true
        int? :canvas_width, cast_str: true
        obj? :background
      end
    end

    model ::SeatMap

    private

    def build_model
      @model = LanParty.find(osparams.lan_party_id).seat_map
      build_nested_model_ops :update
      assign_attributes
    end
  end
end
