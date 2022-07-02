class AdminBackofficeController < ApplicationController
  rescue_from Errno::ECONNREFUSED, with: :connection_refused
  rescue_from Faraday::ConnectionFailed, with: :connection_refused 
  before_action :authenticate_admin!

  def connection_refused
    flash[:notice] = I18n.t(:connection_rejected_message)
  end
end
