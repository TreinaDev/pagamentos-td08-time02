class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name registration_number])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[status])
  end
end
