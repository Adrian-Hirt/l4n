module Operations::Admin::SeatCategory
  class Load < RailsOps::Operation::Model::Load
    schema3 do
      str! :id
    end

    model ::SeatCategory
  end
end
