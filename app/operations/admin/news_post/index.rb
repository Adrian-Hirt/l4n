module Operations::Admin::NewsPost
  class Index < RailsOps::Operation
    policy :on_init do
      authorize! :manage, NewsPost
    end

    def posts
      NewsPost.all
    end
  end
end
