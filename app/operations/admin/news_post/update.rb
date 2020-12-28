module Operations::Admin::NewsPost
  class Update < RailsOps::Operation::Model::Update
    schema do
      req :id
      opt :news_post do
        opt :title
        opt :content
        opt :published
      end
    end

    model ::NewsPost

    def perform
      if model.published_changed?
        model.published_at = (Time.zone.now if model.published?)
      end

      super
    end
  end
end
