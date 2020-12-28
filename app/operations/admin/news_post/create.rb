module Operations::Admin::NewsPost
  class Create < RailsOps::Operation::Model::Create
    schema do
      opt :news_post do
        opt :title
        opt :content
        opt :published
      end
    end

    model ::NewsPost

    def perform
      model.user = context.user
      model.published_at = Time.zone.now if model.published?

      super
    end
  end
end
