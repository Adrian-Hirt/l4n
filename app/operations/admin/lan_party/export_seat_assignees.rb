require 'csv'

module Operations::Admin::LanParty
  class ExportSeatAssignees < RailsOps::Operation::Model::Load
    schema3 do
      int! :id, cast_str: true
    end

    model ::LanParty

    def csv_data
      ::CSV.generate do |csv|
        csv << %w[seat_name user_name user_id]

        model.seat_map.seats.order(:id).each do |seat|
          csv << [seat.name_or_id, seat.ticket&.assignee&.username, seat.ticket&.assignee&.id]
        end
      end
    end

    def json_data
      data = model.seat_map.seats.order(:id).map do |seat|
        {
          seat_name: seat.name_or_id,
          user_name: seat.ticket&.assignee&.username,
          user_id:   seat.ticket&.assignee&.id
        }
      end

      data.to_json
    end
  end
end
