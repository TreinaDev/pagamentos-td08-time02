class AdminBackoffice::CreditLimitsController < ApplicationController
  def new
    @credit_limit = CreditLimit.new
  end

  def create
    @credit_limit = CreditLimit.new(credit_limit_params)
    if @credit_limit.save
      redirect_to root_path, notice: I18n.t(:credit_limit_create_success)
    else
      flash.now[:notice] = I18n.t(:credit_limit_create_fail)
      render 'new'
    end
  end

  private
  
  def credit_limit_params
    params.require(:credit_limit).permit(:max_limit)
  end
end