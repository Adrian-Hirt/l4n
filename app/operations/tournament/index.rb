module Operations::Tournament
  class Index < RailsOps::Operation
    policy :on_init do
      authorize! :read, Tournament
    end

    def tournaments
      @tournaments ||= ::Tournament.accessible_by(context.ability)
                                   .where(status: Tournament.statuses[:published])
                                   .order(:name)
    end
  end
end
