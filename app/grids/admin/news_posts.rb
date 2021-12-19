module Grids
  module Admin
    class NewsPosts
      include Datagrid

      scope do
        NewsPost.all
      end

      column :title, header: _('NewsPosts|Title')
      column :published, header: _('NewsPosts|Published'), html: ->(published) { format_boolean(published) }
      column :published_at, header: _('NewsPosts|Published at'), html: ->(published_at) { l(published_at) }
      column :user, header: _('NewsPosts|Author'), html: ->(user) { user.username }
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
