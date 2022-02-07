module Operations::Admin::Order
  class Load < RailsOps::Operation::Model::Load
    schema3 do
      int! :id, cast_str: true
    end

    model ::Order

    def perform
      super
      model.includes(:order_items)
    end
  end
end
