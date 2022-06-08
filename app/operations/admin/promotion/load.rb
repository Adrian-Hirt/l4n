module Operations::Admin::Promotion
  class Load < RailsOps::Operation::Model::Load
    schema3 do
      str! :id
      str? :page
      hsh? :grids_admin_promotion_codes, additional_properties: true
    end

    model ::Promotion

    def codes_grid
      @codes_grid ||= Grids::Admin::PromotionCodes.new(osparams.grids_admin_promotion_codes) do |scope|
        scope.page(params[:page])
      end
    end
  end
end
