class AdminBackofficeController < ApplicationController
  before_action :authenticate_admin!
end