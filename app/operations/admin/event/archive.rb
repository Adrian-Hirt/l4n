module Operations::Admin::Event
  class Archive < RailsOps::Operation
    schema3 do
      str? :page
      hsh? :grids_admin_events_archive, additional_properties: true
    end

    policy :on_init do
      authorize! :manage, Event
    end

    def grid
      @grid ||= Grids::Admin::EventsArchive.new(osparams.grids_admin_events_archive) do |scope|
        scope.page(params[:page])
      end
    end
  end
end
