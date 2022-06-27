class AdminBackoffice::CurrenciesController < AdminBackofficeController
  before_action :authorize_active_admin
  before_action :check_pending, only: [:new, :create]

  def index
    @currencies = Currency.all.order(created_at: :desc)
    Currency.set_inactive_if_3_days_ago
  end

  def new
    @currency = Currency.new
    @admin = current_admin
  end

  def create
    @admin = current_admin
    @currency = Currency.new(params.require(:currency).permit(:currency_value).merge(admin_id: @admin.id))

    @currency.save
    redirect_to admin_backoffice_currencies_path, notice: 'Taxa de Câmbio criada com sucesso.'
    params = { exchange_rate: @currency.currency_value }
    Faraday.post('http://localhost:3000/api/v1/exchange_rates', params) 
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
      params = { exchange_rate: @currency.currency_value }
      Faraday.post('http://localhost:3000/api/v1/exchange_rates', params) 
    end
  end

  def reject
    @currency = Currency.find(params[:id])
    @currency.inactive!
    redirect_to admin_backoffice_currencies_path, notice: 'Taxa rejeitada com sucesso!'
  end

  private

  def authorize_active_admin
    unless current_admin.active?
      redirect_to root_path, notice: 'Você não tem acesso ao sistema. Aguarde a liberação para acessar a página.'
    end
  end

  def check_pending
    if Currency.pending.any?
      redirect_to admin_backoffice_currencies_path, notice: 'Não pode ser criada nova taxa enquanto tiver uma pendente.'
    end
  end
end