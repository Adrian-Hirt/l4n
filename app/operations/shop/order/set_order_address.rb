module Operations::Shop::Order
  class SetOrderAddress < RailsOps::Operation::Model::Update
    schema3 do
      int! :id, cast_str: true
      hsh? :order do
        str? :billing_address_first_name
        str? :billing_address_last_name
        str? :billing_address_street
        str? :billing_address_zip_code
        str? :billing_address_city
      end
    end

    model ::Order

    load_model_authorization_action :read_public

    def order
      model
    end
  end
end
