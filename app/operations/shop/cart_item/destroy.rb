module Operations::Shop::CartItem
  class Destroy < RailsOps::Operation::Model::Destroy
    schema3 do
      int! :id, cast_str: true
    end

    policy :on_init do
      authorize! :use, :shop
    end

    load_model_authorization_action nil
    model_authorization_action nil

    model ::CartItem
  end
end
