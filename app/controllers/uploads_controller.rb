class UploadsController < ApplicationController
  def show
    upload = Upload.find_by!(uuid: params[:id])
    send_data upload.file.download, content_type: upload.file.blob.content_type, disposition: 'inline'
  end
end
