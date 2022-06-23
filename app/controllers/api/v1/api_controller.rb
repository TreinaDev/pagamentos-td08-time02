class Api::V1::ApiController < ActionController::API
  rescue_from ActiveRecord::ActiveRecordError, with: :return_status_500
  rescue_from ActiveRecord::RecordNotFound, with: :return_status_404

  private

  def return_status_500

    head :internal_server_error
  end
  
  def return_status_404
    head :not_found
  end
end
