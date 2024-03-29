module Operations::Application
  class Sidebar < RailsOps::Operation
    schema3 {} # No params here

    def lan_party_block
      # Check that the lan party feature flag is enabled
      return unless FeatureFlag.enabled?(:lan_party)

      # Check that the config setting is enabled
      return unless AppConfig.enable_lan_party_block

      active_lan_parties_with_sidebar = Queries::LanParty::FetchActive.run.where(sidebar_active: true)

      return unless active_lan_parties_with_sidebar.any?

      ApplicationController.render partial: 'shared/sidebar/lan_party', locals: { user: context.user }, collection: active_lan_parties_with_sidebar
    end

    def next_events_block
      # Check that the news feature flag is enabled
      return unless FeatureFlag.enabled?(:events)

      # Check that the config setting is enabled
      return unless AppConfig.enable_events_block

      next_relevant_events = Queries::Event::FetchFutureEvents.call.where(published: true).first(3)

      ApplicationController.render partial: 'shared/sidebar/next_events', locals: { events: next_relevant_events } if next_relevant_events.any?
    end

    def news_block
      # Check that the news feature flag is enabled
      return unless FeatureFlag.enabled?(:news_posts)

      # Check that the config setting is enabled
      return unless AppConfig.enable_news_block

      relevant_news = ::NewsPost.where(published: true).order(published_at: :desc).first(3)

      ApplicationController.render partial: 'shared/sidebar/news', locals: { news_posts: relevant_news } if relevant_news.any?
    end

    def dynamic_sidebar_blocks
      # Get all enabled sidebar blocks
      enabled_sidebar_blocks = ::SidebarBlock.where(visible: true).order(:sort)

      # Create an output buffer
      output = ActiveSupport::SafeBuffer.new

      # Render all blocks
      enabled_sidebar_blocks.each do |sidebar_block|
        output << ApplicationController.render(partial: 'shared/sidebar/dynamic_sidebar_block', locals: { sidebar_block: sidebar_block })
      end

      output
    end
  end
end
