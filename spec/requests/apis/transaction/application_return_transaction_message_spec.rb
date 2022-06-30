require 'rails_helper'

describe 'Aplicação retorna status transação' do
  context 'GET /api/v1/transactions' do
    it 'e transação está pendente' do
      create(:admin, status: :active)
      create(:currency)
      create(:client_wallet, balance: 90)
      create(:transaction)

      get "/api/v1/transactions/#{Transaction.first.order}"

      expect(response).to have_http_status(:ok)
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response['order']).to eq('1')
      expect(json_response['registered_number']).to eq('111.111.111-11')
      expect(json_response['status']).to eq('pending')
    end

    it 'e transação foi aceita' do
      create(:admin, status: :active)
      create(:currency)
      create(:client_wallet, balance: 1000)
      create(:transaction)

      Transaction.last.accepted!
      get "/api/v1/transactions/#{Transaction.first.order}"

      expect(response).to have_http_status(:ok)
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response['order']).to eq('1')
      expect(json_response['registered_number']).to eq('111.111.111-11')
      expect(json_response['status']).to eq('accepted')
    end

    it 'e transação foi rejeitada' do
      create(:admin, status: :active)
      create(:currency)
      create(:client_wallet, balance: 90)
      create(:transaction)

      Transaction.first.rejected!
      Transaction.first.update(message: 'Não pode')
      get "/api/v1/transactions/#{Transaction.first.order}"

      expect(response).to have_http_status(:ok)
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response['order']).to eq('1')
      expect(json_response['registered_number']).to eq('111.111.111-11')
      expect(json_response['status']).to eq('rejected')
      expect(json_response['message']).to include(Transaction.last.message.to_s)
    end

    it 'e transação não existe' do
      get '/api/v1/transactions/99'

      expect(response).to have_http_status(:not_found)
    end
  end
end
