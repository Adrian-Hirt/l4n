module Operations::Api::V1::News
  class Index < RailsOps::Operation
    schema3 {} # No params allowed for now

    # No auth, applications are authenticated via their API key

    def result
      result = []

      :: NewsPost.where(published: true).each do |news_post|
        result << {
          title:        news_post.title,
          content:      news_post.content,
          url:          context.view.news_url(news_post),
          published_at: news_post.published_at.to_time.iso8601,
          author:       {
            name: news_post.user.username
          }
        }
      end

      result
    end
  end
end
