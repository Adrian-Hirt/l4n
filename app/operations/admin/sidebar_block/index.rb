module Operations::Admin::SidebarBlock
  class Index < RailsOps::Operation
    schema3 do
      str? :page
      hsh? :grids_admin_sidebar_blocks, additional_properties: true
    end

    policy :on_init do
      authorize! :manage, SidebarBlock
    end

    def grid
      @grid ||= Grids::Admin::SidebarBlocks.new(osparams.grids_admin_sidebar_blocks) do |scope|
        scope.page(params[:page])
      end
    end
  end
end
