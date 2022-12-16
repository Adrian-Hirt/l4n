module Operations::Admin::Product
  class Update < RailsOps::Operation::Model::Update
    schema do
      req :id
      opt :lan_party
      opt :product do
        opt :name
        opt :on_sale
        opt :description
        opt :inventory
        opt :enabled_product_behaviours
        opt :images
        opt :remove_images
        opt :product_variants_attributes
        opt :seat_category_id
        opt :to_product_id
        opt :from_product_id
        opt :product_category_id
        opt :sort
      end
    end

    model ::Product do
      attribute :remove_images

      validate :not_used_as_from_or_to

      private

      def not_used_as_from_or_to
        used_as_to_or_from = Product.where('to_product_id = ? OR from_product_id = ?', id, id).any?

        # Early return if not used
        return unless used_as_to_or_from

        # Check that the seat category has not changed if it's used as the TO or FROM product elsewhere
        errors.add(:seat_category, _('Product|TicketBehaviour|Cannot be changed as this product is used as the to or from product elsewhere!')) if seat_category_changed?

        # Check that the enabled product behaviours have not changed if it's used as the TO or FROM product elsewhere
        errors.add(:enabled_product_behaviours, _('Product|TicketBehaviour|Cannot be changed as this product is used as the to or from product elsewhere!')) if enabled_product_behaviours_changed?
      end
    end

    def perform
      difference = model.inventory - model.inventory_was
      model.availability += difference
      model.total_inventory += difference

      # Remove the seat_category_id if it was not given
      model.seat_category_id = osparams.product[:seat_category_id]

      super

      return unless model.valid?

      osparams.product[:remove_images]&.each do |id_to_remove|
        model.images.find(id_to_remove).purge
      end
    end
  end
end
