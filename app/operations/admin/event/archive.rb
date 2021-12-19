module Operations::Admin::Event
  class Archive < RailsOps::Operation
    policy :on_init do
      authorize! :manage, Event
    end

    def grid
      @grid ||= Grids::Admin::EventsArchive.new(osparams.grids_events) do |scope|
        scope.page(params[:page])
      end
    end
  end
end
