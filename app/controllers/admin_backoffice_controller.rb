class AdminBackofficeController < ApplicationController
  rescue_from Errno::ECONNREFUSED, with: :connection_refused
  before_action :authenticate_admin!

  def connection_refused
    flash[:notice] = :connection_rejected_message
  end
end