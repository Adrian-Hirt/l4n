module Operations::Admin::Promotion
  class Load < RailsOps::Operation::Model::Load
    schema3 do
      str! :id
      str? :page
      hsh? :grids_admin_promotion_codes, additional_properties: true
    end

    model ::Promotion

    def codes_grid
      grid_params = osparams.grids_admin_promotion_codes || {}
      grid_params[:promotion] = model

      @codes_grid ||= Grids::Admin::PromotionCodes.new(grid_params) do |scope|
        scope.page(params[:page])
      end
    end
  end
end
