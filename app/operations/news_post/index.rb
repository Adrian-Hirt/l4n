module Operations::NewsPost
  class Index < RailsOps::Operation
    policy :on_init do
      authorize! :read, NewsPost
    end

    schema3 do
      str? :page
    end

    def posts
      ::NewsPost.where(published: true).order(published_at: :desc).page(osparams.page)
    end
  end
end
