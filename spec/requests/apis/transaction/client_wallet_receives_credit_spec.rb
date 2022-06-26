require 'rails_helper'

describe 'Carteira do cliente recebe crédito via API' do
  context 'POST /api/v1/credits' do
    it 'com sucesso' do
      create(:admin, status: :active)
      currency = create(:currency)
      client_wallet = create(:client_wallet, balance: 500)
      balance = client_wallet.balance
      credit_params = { credit: { registered_number: client_wallet.registered_number, value: 500 } }

      post '/api/v1/credits', params: credit_params

      expect(response).to have_http_status(:created)
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response['status']).to eq('approved')
      expect(json_response['message']).to eq('Transação aprovada')
      client_wallet.reload
      expect(client_wallet.balance).to eq((balance + (500 / currency.currency_value)).to_i)
    end
  
    it 'com sucesso e conversão bônus' do
      bonus_conversion = create(:bonus_conversion, percentage: 10)
      currency = create(:currency)
      client_wallet = create(:client_wallet, balance: 500, category: create(:category, bonus_conversion_id: bonus_conversion.id))
      balance = client_wallet.balance
      credit_params = { credit: { registered_number: client_wallet.registered_number, value: 500 } }

      post '/api/v1/credits', params: credit_params

      expect(response).to have_http_status(:created)
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response['status']).to eq('approved')
      expect(json_response['message']).to eq('Transação aprovada')
      client_wallet.reload
      expect(client_wallet.balance).to eq((balance + (500 / currency.currency_value)).to_i)
      expect(client_wallet.bonus_balance).to eq(((500 /currency.currency_value) *
                                                (client_wallet.category.bonus_conversion.percentage * 0.01)).to_i)
    end
  end
end