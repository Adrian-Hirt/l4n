module Grids
  module Admin
    class NewsPosts
      include Datagrid

      scope do
        NewsPost.all
      end

      column :title, header: _('NewsPosts|Title')
      column :published, header: _('NewsPosts|Published'), html: true do |news_post|
        format_boolean(news_post.published)
      end
      column :published_at, header: _('NewsPosts|Published at'), html: true do |news_post|
        l(news_post.published_at)
      end
      column :user, header: _('NewsPosts|Author'), html: true do |news_post|
        news_post.user.username
      end

      column :'datagrid-actions', html: true, header: '' do |news_post|
        tag.div class: %i[datagrid-actions-wrapper] do
          safe_join([
                      edit_button(news_post, namespace: %i[admin], size: :sm, icon_only: true),
                      delete_button(news_post, namespace: %i[admin], size: :sm, icon_only: true)
                    ])
        end
      end
    end
  end
end
