class AdminBackoffice::CurrenciesController < AdminBackofficeController
  before_action :authorize_active_admin
  before_action :set_inactive_if_3_days_ago

  def index
    @currencies = Currency.all.order(created_at: :desc)
  end

  def new
    @currency = Currency.new
    @admin = current_admin
  end

  def create
    @admin = current_admin
    @currency = Currency.new(params.require(:currency).permit(:currency_value).merge(admin_id: @admin.id))

    @currency.save!
    redirect_to admin_backoffice_currencies_path, notice: 'Taxa de Câmbio criada com sucesso.'
  end

  def approve
    @currency = Currency.find(params[:id])

    if current_admin.id == @currency.admin_id
      redirect_to admin_backoffice_currencies_path,
                  notice: 'Você não pode aprovar essa taxa, solicite a outro administrador.'
    else
      @currency.active!
      @currencies = Currency.last(2)
      @currencies.first.inactive!
      redirect_to admin_backoffice_currencies_path, notice: 'Taxa aprovada com sucesso!'
    end
  end

  private

  def authorize_active_admin
    unless current_admin.active?
      redirect_to root_path, notice: 'Você não tem acesso ao sistema. Aguarde a liberação para acessar a página.'
    end
  end

  def set_inactive_if_3_days_ago
    @currency = Currency.last
    @currency.inactive! if !@currency.nil? && @currency.created_at.to_date < 3.days.ago
  end
end
