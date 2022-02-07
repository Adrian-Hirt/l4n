module Operations::Shop::Order
  class SetOrderAddress < RailsOps::Operation::Model::Update
    model ::Order

    attr_reader :no_address_given_error

    def perform
      if osparams.selected_address_id.blank?
        @no_address_given_error = true
        return
      end

      address = context.user.user_addresses.find(osparams.selected_address_id)

      model.billing_address_first_name = address.first_name
      model.billing_address_last_name = address.last_name
      model.billing_address_street = address.street
      model.billing_address_zip_code = address.zip_code
      model.billing_address_city = address.city
      model.save!
    end

    def order
      model
    end
  end
end