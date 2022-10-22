module Operations::Api::V1::News
  class Load < RailsOps::Operation
    schema3 do
      int! :id, cast_str: true
    end

    # No auth, applications are authenticated via their API key

    def result
      news_post = ::NewsPost.find(osparams.id)

      fail ActiveRecord::NotFound unless news_post.published?

      {
        title:        news_post.title,
        content:      news_post.content,
        url:          context.view.news_url(news_post),
        published_at: news_post.published_at.to_time.iso8601,
        author:       {
          name: news_post.user.username
        }
      }
    end
  end
end
