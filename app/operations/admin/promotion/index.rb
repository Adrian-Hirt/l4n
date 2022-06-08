module Operations::Admin::Promotion
  class Index < RailsOps::Operation
    policy :on_init do
      authorize! :manage, Promotion
    end

    def grid
      @grid ||= Grids::Admin::Promotions.new(osparams.grids_admin_promotions) do |scope|
        scope.page(params[:page])
      end
    end
  end
end
