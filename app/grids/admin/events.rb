module Grids
  module Admin
    class Events
      include Datagrid

      scope do
        Queries::Event::FetchFutureEvents.run
      end

      column :title, header: _('Event|Title')
      column :location, header: _('Event|Location')
      column :published, header: _('Event|Published'), html: true do |event|
        format_boolean(event.published)
      end
      column :next_start_date, html: true, header: _('Event|Next start') do |event|
        l(event.next_date.start_date) || '-'
      end
      column :next_end_date, html: true, header: _('Event|Next end') do |event|
        l(event.next_date.end_date) || '-'
      end
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
