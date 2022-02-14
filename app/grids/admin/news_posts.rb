module Grids
  module Admin
    class NewsPosts < ApplicationGrid
      scope do
        NewsPost.order(:title)
      end

      model NewsPost

      column :title
      column :published, html: ->(published) { format_boolean(published) }
      column :published_at, html: ->(published_at) { l(published_at) if published_at.present? }
      column :user, header: _('NewsPosts|Author'), html: ->(user) { user.username }
      column :'datagrid-actions', html: true, header: false do |news_post|
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
