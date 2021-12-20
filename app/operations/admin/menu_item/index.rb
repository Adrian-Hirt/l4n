module Operations::Admin::MenuItem
  class Index < RailsOps::Operation
    policy :on_init do
      authorize! :manage, MenuItem
    end

    def grid
      @grid ||= Grids::Admin::MenuItems.new(osparams.grids_menu_items) do |scope|
        scope.page(params[:page])
      end
    end
  end
end
