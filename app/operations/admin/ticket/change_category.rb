module Operations::Admin::Ticket
  class ChangeCategory < RailsOps::Operation::Model::Load
    schema3 do
      int! :id, cast_str: true
      hsh? :ticket_upgrade do
        int! :category_id, cast_str: true
      end
    end

    model ::Ticket

    lock_mode :exclusive

    def perform
      # Check that to_product is present
      fail Operations::Exceptions::OpFailed, _('Admin|Tickets|To product cannot be found') if to_product.blank?

      # Check that from_product is present
      fail Operations::Exceptions::OpFailed, _('Admin|Tickets|From product cannot be found') if from_product.blank?

      # Check that we still have availability on the to_product
      fail Operations::Exceptions::OpFailed, _('Admin|Tickets|No more to products available') if to_product.availability <= 0

      # Check that the ticket does not have a seat
      fail Operations::Exceptions::OpFailed, _('Admin|Tickets|Please remove the seat first') if model.seat.present?

      # Finally, we can change the category
      ActiveRecord::Base.transaction do
        # Change category
        model.seat_category = new_category
        model.save!

        # Increase availability and inventory of from product
        from_product.availability += 1
        from_product.inventory += 1
        from_product.save!

        # Decrease availability and inventory of to product
        to_product.availability -= 1
        to_product.inventory -= 1
        to_product.save!

        # Sanity check
        fail Operations::Exceptions::OpFailed, _('Admin|Tickets|No more to products available') if to_product.availability.negative?
      end
    end

    private

    def new_category
      @new_category ||= SeatCategory.find_by(id: osparams.ticket_upgrade[:category_id])
    end

    def to_product
      @to_product ||= Product.find_by(seat_category: new_category)
    end

    def from_product
      @from_product ||= Product.find_by(seat_category: model.seat_category)
    end
  end
end
