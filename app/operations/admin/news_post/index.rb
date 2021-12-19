module Operations::Admin::NewsPost
  class Index < RailsOps::Operation
    policy :on_init do
      authorize! :manage, NewsPost
    end

    def grid
      @grid ||= Grids::Admin::NewsPosts.new(osparams.grids_news_posts) do |scope|
        scope.page(params[:page])
      end
    end
  end
end
