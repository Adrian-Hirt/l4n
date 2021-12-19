module Operations::Admin::Event
  class Index < RailsOps::Operation
    policy :on_init do
      authorize! :manage, Event
    end

    def grid
      @grid ||= Grids::Admin::Events.new(osparams.grids_admin_events) do |scope|
        scope.page(params[:page])
      end
    end
  end
end
