module Operations::Admin::Ticket
  class Create < RailsOps::Operation::Model::Create
    schema3 do
      int! :lan_party_id, cast_str: true
      hsh? :ticket do
        obj? :seat_category_id
      end
    end

    model ::Ticket

    def perform
      ActiveRecord::Base.transaction do
        # Assign the lan_party
        model.lan_party = lan_party

        # Check if there is a product with the seat_category we want to assign.
        # If yes, we'll have to check that we still have availability, and if
        # yes, we have to change the availability and inventory accordingly.
        product = Product.find_by(seat_category_id: osparams.ticket[:seat_category_id])

        if product.present?
          # Decrease availability
          product.availability -= 1

          # Check that we still have the product available
          if product.availability.negative?
            model.errors.add(:seat_category_id, _('Admin|Ticket|Product is not available anymore'))
            fail Operations::Exceptions::OpFailed, _('Admin|Ticket|Product is not available anymore')
          end

          # Update the inventory
          product.inventory -= 1

          # Save the product
          product.save!
        end

        # Run the create method
        super
      end
    end

    def available_seat_categories
      categories = {}

      in_shop_categories = []
      not_in_shop_categories = []

      lan_party.seat_categories.includes(:product).order(:name).each do |seat_category|
        if seat_category.product.present?
          in_shop_categories << ["#{seat_category.name} (#{_('Product|Availability')}: #{seat_category.product.availability})", seat_category.id]
        else
          not_in_shop_categories << [seat_category.name, seat_category.id]
        end
      end

      categories[_('Admin|Ticket|Sold in shop')] = in_shop_categories
      categories[_('Admin|Ticket|Not in shop')] = not_in_shop_categories

      categories
    end

    def lan_party
      @lan_party ||= ::LanParty.find(osparams.lan_party_id)
    end
  end
end
