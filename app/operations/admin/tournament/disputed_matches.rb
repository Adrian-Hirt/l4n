module Operations::Admin::Tournament
  class DisputedMatches < RailsOps::Operation
    schema3 {} # No params allowed

    policy :on_init do
      authorize! :manage, Tournament
    end

    def matches
      @matches ||= Tournament::Match.accessible_by(context.ability).where(result_status: 'disputed')
    end
  end
end
