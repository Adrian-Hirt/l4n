module Operations::Lan::SeatMap
  class Load < RailsOps::Operation::Model
    policy :on_init do
      authorize! :read, SeatMap
    end

    model ::SeatMap

    def lan_party
      @lan_party ||= LanParty.find_by(active: true)
    end

    def model
      @model ||= lan_party.seat_map
    end

    def seat_category_data
      lan_party.seat_categories.map { |category| [category.name, category.id, { data: { color: category.color } }] }
    end

    def seat_map_data
      ActiveStorage::Current.set(host: context.view.request.base_url) do
        {
          backgroundHeight: model.background_height,
          backgroundWidth:  model.background_width,
          canvasHeight:     model.canvas_height,
          canvasWidth:      model.canvas_width,
          backgroundUrl:    model.background.url
        }.to_json
      end
    end
  end
end
