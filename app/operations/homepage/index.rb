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

    def render_content_blocks
      # Find visible content blocks
      visible_blocks = StartpageBlock.where(visible: true).order(:sort)

      # Return if no blocks are visible or the visible banner has no images
      return if visible_blocks.none?

      # Otherwise, render the blocks
      context.view.render partial: 'content_block', collection: visible_blocks, cached: true
    end
  end
end
