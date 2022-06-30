class HomeController < ApplicationController
  def index
    @credits = CreditLimit.all
  end
end