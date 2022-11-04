module Operations::Admin::SeatCategory
  class Update < RailsOps::Operation::Model::Update
    schema3 do
      int! :id, cast_str: true
      hsh? :seat_category do
        str? :name
        str? :color
        str? :relevant_for_counter
      end
    end

    model ::SeatCategory
  end
end
