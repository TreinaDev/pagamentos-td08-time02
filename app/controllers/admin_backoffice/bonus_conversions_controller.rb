class AdminBackoffice::BonusConversionsController < AdminBackofficeController
  def index
    @bonus_conversions = BonusConversion.all
  end

  def new
    @bonus_conversion = BonusConversion.new
  end

  def create
    @bonus_conversion = BonusConversion.new(bonus_conversion_params)
    if @bonus_conversion.save
      redirect_to admin_backoffice_bonus_conversions_path,
                  notice: t(:bonus_conversion_success)
    else
      flash.now[:alert] = t(:bonus_conversion_fail)
      render :new
    end
  end

  private

  def bonus_conversion_params
    params.require(:bonus_conversion)
          .permit(:initial_date, :final_date, :percentage, :deadline)
          .merge(admin: current_admin)
  end
end
