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
    redirect_to admin_backoffice_currencies_path, notice: t(:currency_created)
    params = { exchange_rate: @currency.currency_value }
    Faraday.post('http://localhost:3000/api/v1/exchange_rates', params)
  end

  def approve
    @currency = Currency.find(params[:id])
    if current_admin.id == @currency.admin_id
      redirect_to admin_backoffice_currencies_path,
                  alert: t(:fail_approved)
    else
      @currency.active!
      @currencies = Currency.last(2)
      @currencies.first.inactive!
      redirect_to admin_backoffice_currencies_path, notice: t(:success_approved)
      params = { exchange_rate: @currency.currency_value }
      Faraday.post('http://localhost:3000/api/v1/exchange_rates', params) 
    end
  end

  def reject
    @currency = Currency.find(params[:id])
    @currency.inactive!
    redirect_to admin_backoffice_currencies_path, notice: t(:success_rejected)
  end

  private

  def authorize_active_admin
    unless current_admin.active?
      redirect_to root_path, notice: t(:fail_access)
    end
  end

  def check_pending
    if Currency.pending.any?
      redirect_to admin_backoffice_currencies_path, notice: t(:error_pending_currency)
    end
  end
end