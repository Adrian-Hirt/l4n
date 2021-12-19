module Grids
  module Admin
    class Events
      include Datagrid

      scope do
        Queries::Event::FetchFutureEvents.run
      end

      column :title, header: _('Event|Title')
      column :location, header: _('Event|Location')
      column :published, header: _('Event|Published'), html: ->(published) { format_boolean(published) }
      column :next_date, header: _('Event|Next start'), html: ->(next_date) { l(next_date.start_date) }
      column :next_date, header: _('Event|Next end'), html: ->(next_date) { l(next_date.end_date) }
      column :'datagrid-actions', html: true, header: '' do |event|
        tag.div class: %i[datagrid-actions-wrapper] do
          safe_join([
                      edit_button(event, namespace: %i[admin], size: :sm, icon_only: true),
                      delete_button(event, namespace: %i[admin], size: :sm, icon_only: true)
                    ])
        end
      end
    end
  end
end
