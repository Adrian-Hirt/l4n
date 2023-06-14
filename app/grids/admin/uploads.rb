module Grids
  module Admin
    class Uploads < ApplicationGrid
      scope do
        Upload.order(:created_at)
      end

      model Upload

      column :filename, header: _('Upload|Filename'), html: true do |upload|
        upload.file&.blob&.filename
      end
      column :user, header: _('Upload|Uploaded by'), html: ->(user) { user&.username.presence || '-' }
      column :size, header: _('Upload|Size'), html: true do |upload|
        number_to_human_size(upload.file&.blob&.byte_size)
      end
      column :type, header: _('Upload|Type'), html: true do |upload|
        upload.file&.blob&.content_type
      end
      column :created_at, header: _('Upload|Uploaded at'), html: ->(created_at) { l created_at }

      column :'datagrid-actions', html: true, header: false do |upload|
        tag.div class: %i[datagrid-actions-wrapper] do
          safe_join([
                      show_button(upload, href: upload_path(upload.uuid), size: :sm, icon_only: true, html: { target: :_blank }),
                      can?(:delete, Upload) ? delete_button(upload, namespace: %i[admin], size: :sm, icon_only: true) : nil
                    ])
        end
      end

      filter :content_type, :enum, select:        Upload.joins(file_attachment: :blob).pluck(:content_type).uniq.sort,
                                   include_blank: _('Form|Select|Show all') do |value, scope, _grid|
        scope.joins(file_attachment: :blob).where(blob: { content_type: value })
      end

      filter :uploaded_by, :enum, select:        User.where(id: Upload.all.select(:user_id)).map { |user| [user.username, user.id] }.sort << ['-', 0],
                                  include_blank: _('Form|Select|Show all') do |value, scope, _grid|
        if value == '0'
          scope.where(user_id: nil)
        else
          scope.where(user_id: value)
        end
      end
    end
  end
end
