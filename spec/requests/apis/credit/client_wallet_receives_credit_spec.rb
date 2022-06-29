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
      expect(json_response['message']).to eq('Crédito aprovado')
      client_wallet.reload
      expect(client_wallet.balance).to eq((balance + ((500 / currency.currency_value) * 100.0)).to_i)
    end

    it 'com sucesso e com conversão bônus' do
      bonus_conversion = create(:bonus_conversion, percentage: 10)
      currency = create(:currency)
      client_wallet = create(:client_wallet, balance: 500,
                                             category: create(:category, bonus_conversion_id: bonus_conversion.id))
      balance = client_wallet.balance
      credit_params = { credit: { registered_number: client_wallet.registered_number, value: 500 } }

      post '/api/v1/credits', params: credit_params

      expect(response).to have_http_status(:created)
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response['status']).to eq('approved')
      expect(json_response['message']).to eq('Crédito aprovado')
      client_wallet.reload

      expect(client_wallet.balance).to eq((balance + ((500 / currency.currency_value) * 100)).to_i)
      expect(client_wallet.bonus_balance).to eq(((((500 / currency.currency_value) * 100).to_i *
                                                (client_wallet.category.bonus_conversion.percentage / 100.0))).to_i)
    end

    it 'e não há taxa de câmbio ativa' do
      client_wallet = create(:client_wallet, balance: 500)
      credit_params = { credit: { registered_number: client_wallet.registered_number, value: 500 } }

      post '/api/v1/credits', params: credit_params

      expect(response).to have_http_status(:not_found)
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response['error']).to eq('Não há uma taxa de câmbia ativa')
    end

    it 'com valor em R$ acima do limite de crédito diário e fica pendente de aprovação' do
      create(:credit_limit, max_limit: 1000)
      create(:admin, status: :active)
      create(:currency)
      client_wallet = create(:client_wallet)
      balance = client_wallet.balance
      credit_params = { credit: { registered_number: client_wallet.registered_number, value: 1001 } }

      post '/api/v1/credits', params: credit_params
      
      expect(response).to have_http_status(:created)
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response['status']).to eq('pending')
      expect(json_response['message']).to eq('Crédito acima do limite permitido. Aguardando aprovação.')
      client_wallet.reload
      expect(client_wallet.balance).to eq(balance)
    end
  end
end
