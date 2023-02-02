module Operations::Shop::Order
  class AcceptGtcs < RailsOps::Operation::Model::Load
    schema3 do
      int! :id, cast_str: true
    end

    model ::Order

    load_model_authorization_action :read_public

    def perform
      model.gtcs_accepted = true
      model.save!
    end

    def order
      model
    end
  end
end
