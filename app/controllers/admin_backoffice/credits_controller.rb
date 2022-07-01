class AdminBackoffice::CreditsController < ApplicationController
  before_action :set_credit, only: %i[approve refuse]

  def index
    @credits = Credit.pending
  end

  def approve
    @credit.accepted!
    @credit.update_client_wallet
    redirect_to(admin_backoffice_credits_path, notice: t(:credit_approved_success))
  end

  def refuse
    @credit.refused!
    redirect_to(admin_backoffice_credits_path, notice: t(:credit_rejected_success))
  end

  private

  def set_credit
    @credit = Credit.find(params[:id])
  end


end