module Operations::Admin::StartpageBlock
  class Index < RailsOps::Operation
    schema3 do
      str? :page
      hsh? :grids_admin_startpage_blocks, additional_properties: true
    end

    policy :on_init do
      authorize! :manage, StartpageBlock
    end

    def grid
      @grid ||= Grids::Admin::StartpageBlocks.new(osparams.grids_admin_startpage_blocks) do |scope|
        scope.page(params[:page])
      end
    end
  end
end
