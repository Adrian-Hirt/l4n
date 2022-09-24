module Operations::Tournament
  class Index < RailsOps::Operation
    policy :on_init do
      authorize! :read, Tournament
    end

    def tournaments
      @tournaments ||= ::Tournament.accessible_by(context.ability)
                                   .where(status: Tournament.statuses[:published])
                                   .order(frontend_order: :desc, name: :asc)
                                   .includes(:lan_party)
    end
  end
end
