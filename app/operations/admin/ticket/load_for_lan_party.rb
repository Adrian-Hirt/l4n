module Operations::Admin::Ticket
  class LoadForLanParty < RailsOps::Operation
    schema3 do
      str! :lan_party_id
      hsh? :grids_admin_tickets, additional_properties: true
    end

    policy :on_init do
      authorize! :read, Ticket
    end

    def lan_party
      @lan_party ||= LanParty.find(osparams.lan_party_id)
    end

    def grid
      grid_params = osparams.grids_admin_tickets || {}
      grid_params[:lan_party] = lan_party

      @grid ||= Grids::Admin::Tickets.new(grid_params) do |scope|
        scope.page(params[:page])
      end
    end
  end
end
