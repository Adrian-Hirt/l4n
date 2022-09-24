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
      data = {}

      lan_party.seat_categories.each do |category|
        data[category.id] = {
          name:  category.name,
          color: category.color_for_view
        }
      end

      data
    end

    def seat_map_data
      ActiveStorage::Current.set(host: context.view.request.base_url) do
        {
          backgroundHeight: model.background_height,
          backgroundWidth:  model.background_width,
          canvasHeight:     model.canvas_height,
          canvasWidth:      model.canvas_width,
          backgroundUrl:    model.background.url,
          categories:       seat_category_data
        }.to_json
      end
    end

    def available_tickets
      Queries::Lan::Ticket::LoadForSeatmap.call(user: context.user, lan_party: lan_party).includes(:seat_category, :seat)
    end

    def ticket_for_lan_party
      @ticket_for_lan_party ||= context.user.ticket_for(lan_party)
    end
  end
end
