class DocumentsController < ApplicationController
include DocumentsHelper

  def index
    @documents = Document.all
    render json: @documents, status: :ok
  end

  def show
    @document = Document.find(params[:id])
    response = getObjectFromS3(@document.s3_object)
    puts response.content_type
    send_data response.body, type: response.content_type, status: :ok
  end

  def create
    file = params[:file]
    key = SecureRandom.hex(16)
    response = uploadToS3(file, key)
    if response.code == 200
      @document = Document.new(file: file.original_filename, s3_object: key)
      @document.save
      return render :json =>{ :message => "document uploaded" }, status: :ok
    end
    render :json => { :message => "something went wrong" }
  end

  private
    def document_params
      params.require(:document).permit(:file)
    end
end
