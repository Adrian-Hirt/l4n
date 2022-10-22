module Operations::Admin::NewsPost
  class Index < RailsOps::Operation
    schema3 do
      str? :page
      hsh? :grids_admin_news_posts, additional_properties: true
    end

    policy :on_init do
      authorize! :manage, NewsPost
    end

    def grid
      @grid ||= Grids::Admin::NewsPosts.new(osparams.grids_admin_news_posts) do |scope|
        scope.page(params[:page])
      end
    end
  end
end
