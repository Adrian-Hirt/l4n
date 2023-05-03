module Operations::Admin::SeatCategory
  class Index < RailsOps::Operation
    schema3 do
      int! :lan_party_id, cast_str: true
      str? :page
      hsh? :grids_admin_seat_categories, additional_properties: true
    end

    policy :on_init do
      authorize! :read, SeatCategory
    end

    def lan_party
      @lan_party ||= LanParty.find(osparams.lan_party_id)
    end

    def grid
      grid_params = osparams.grids_admin_seat_categories || {}
      grid_params[:lan_party] = lan_party

      @grid ||= Grids::Admin::SeatCategories.new(grid_params) do |scope|
        scope.page(params[:page])
      end
    end
  end
end
