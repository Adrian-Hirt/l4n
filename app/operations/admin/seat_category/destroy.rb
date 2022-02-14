module Operations::Admin::SeatCategory
  class Destroy < RailsOps::Operation::Model::Destroy
    schema3 do
      str! :id
    end

    model ::SeatCategory
  end
end
