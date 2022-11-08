module Operations::Application
  class Sidebar < RailsOps::Operation
    schema3 {} # No params here

    def lan_party_block
      return unless FeatureFlag.enabled?(:lan_party)

      ApplicationController.render partial: 'shared/sidebar/lan_party_info', locals: { lan_party: LanParty.active, user: context.user } if LanParty.active.present?
    end

    def next_events_block
      return unless FeatureFlag.enabled?(:events)

      next_relevant_events = Queries::Event::FetchFutureEvents.call.first(5)

      ApplicationController.render partial: 'shared/sidebar/next_events', locals: { events: next_relevant_events } if next_relevant_events.any?
    end
  end
end
