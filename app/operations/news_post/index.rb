module Operations::NewsPost
  class Index < RailsOps::Operation
    policy :on_init do
      authorize! :read, NewsPost
    end

    # No auth needed
    without_authorization

    def posts
      # TODO: When pagination is added, put into query class
      ::NewsPost.where(published: true).order(:published_at).page(osparams.page)
    end
  end
end
