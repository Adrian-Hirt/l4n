module Operations::Homepage
  class Index < RailsOps::Operation
    without_authorization

    def render_banner
      # Find visible banner
      visible_banner = StartpageBanner.find_by(visible: true)

      # Return if no banner is visible or the visible banner has no images
      return if visible_banner.nil? || visible_banner.images.count.zero?

      # Otherwise, render the partial
      context.view.render partial: 'banner', locals: { images: visible_banner.images, height: visible_banner.height }
    end
  end
end
