module Operations::Shop::Order
  class AcceptGtcs < RailsOps::Operation::Model::Load
    schema3 do
      int! :id, cast_str: true
    end

    model ::Order

    def perform
      model.gtcs_accepted = true
      model.save!
    end

    def order
      model
    end
  end
end
