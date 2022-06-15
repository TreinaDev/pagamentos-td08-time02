class AdminBackoffice::BonusConversionsController < AdminBackofficeController
  def index
    @bonus_conversions = BonusConversion.all
  end

  def new
    @bonus_conversion = BonusConversion.new
  end

  def create
    if BonusConversion.create(bonus_conversion_params)
      redirect_to admin_backoffice_bonus_conversions_path,
                  notice: 'Conversão bônus cadastrada com sucesso!'
    else
      flash.now[:notice] = 'A conversão bônus não pode ser cadastrada com sucesso!'
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
