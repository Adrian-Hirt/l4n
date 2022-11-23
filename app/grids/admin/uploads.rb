module Grids
  module Admin
    class Uploads < ApplicationGrid
      scope do
        Upload.order(:created_at)
      end

      model Upload

      column :filename, header: _('Upload|Filename'), html: true do |upload|
        upload.file.blob.filename
      end
      column :user, header: _('Upload|Uploaded by'), html: ->(user) { user.username }
      column :size, header: _('Upload|Size'), html: true do |upload|
        number_to_human_size(upload.file.blob.byte_size)
      end
      column :type, header: _('Upload|Type'), html: true do |upload|
        upload.file.blob.content_type
      end
      column :created_at, header: _('Upload|Uploaded at'), html: ->(created_at) { l created_at }

      column :'datagrid-actions', html: true, header: false do |upload|
        tag.div class: %i[datagrid-actions-wrapper] do
          safe_join([
                      show_button(upload, size: :sm, icon_only: true, html: { target: :_blank }),
                      delete_button(upload, namespace: %i[admin], size: :sm, icon_only: true)
                    ])
        end
      end
    end
  end
end
