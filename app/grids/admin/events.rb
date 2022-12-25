module Grids
  module Admin
    class Events < ApplicationGrid
      scope do
        @data ||= Queries::Event::FetchFutureEvents.run
      end

      model Event

      column :title
      column :published, html: ->(published) { format_boolean(published) }
      column :next_date, header: _('Event|Next location'), html: ->(next_date) { next_date.location }
      column :next_date, header: _('Event|Next start'), html: ->(next_date) { l(next_date.start_date) }
      column :next_date, header: _('Event|Next end'), html: ->(next_date) { l(next_date.end_date) }
      column :'datagrid-actions', html: true, header: false do |event|
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
