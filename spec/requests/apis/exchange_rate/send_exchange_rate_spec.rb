require 'rails_helper'

describe 'Exchange Rate API' do
  context '/api/v1/exchange_rate' do
    it 'envia a taxa de cambio atual com sucesso' do
      create(:currency, admin: create(:admin))

      get '/api/v1/current_rate'

      json_response = JSON.parse(response.body)
      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      expect(json_response['currency_value']).to eq 1.5
    end
  end

  it 'retorna erro 500 se há uma falha interna' do
    create(:currency, admin: create(:admin))
    allow(Currency).to receive(:active).and_raise(ActiveRecord::QueryCanceled)

    get '/api/v1/current_rate'
    expect(response.status).to eq 500
  end
end
