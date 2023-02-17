module Operations::Tournament
  class Index < RailsOps::Operation
    schema3 {} # No params allowed for now

    policy :on_init do
      authorize! :read_public, Tournament
    end

    def tournaments
      @tournaments ||= ::Tournament.accessible_by(context.ability, :read_public)
                                   .where(status: Tournament.statuses[:published])
                                   .order(frontend_order: :desc, name: :asc)
                                   .includes(:lan_party)
    end
  end
end
