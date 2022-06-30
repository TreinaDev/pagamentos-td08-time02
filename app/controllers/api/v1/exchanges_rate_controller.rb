class Api::V1::ExchangesRateController < Api::V1::ApiController
  def current_rate
    current_rate = Currency.active.last
    render status: :ok, json: current_rate.as_json(only: %i[currency_value])
  end
end
