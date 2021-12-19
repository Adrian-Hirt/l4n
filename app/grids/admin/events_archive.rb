module Grids
  module Admin
    class EventsArchive
      include Datagrid

      scope do
        Queries::Event::FetchPastEvents.run
      end

      column :title, header: _('Event|Title')
      column :location, header: _('Event|Location')
      column :published, header: _('Event|Published'), html: ->(published) { format_boolean(published) }
      column :last_date, header: _('Event|Last start'), html: ->(last_date) { l(last_date.start_date) }
      column :last_date, header: _('Event|Last end'), html: ->(last_date) { l(last_date.end_date) }
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
