require 'rails_helper'

describe 'Aplicação gera uma transação' do
  context 'POST /api/v1/transaction' do
    it 'de débito com sucesso' do
      create(:admin, status: :active)
      create(:currency)
      create(:client_wallet, balance: 500)
      params_content = { transaction: { registered_number: '111.111.111-11', value: 100 } }
      post '/api/v1/transactions', params: params_content

      expect(response).to have_http_status(:created)
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response['status']).to include('accepted')
    end

    it 'falha se parametros incompletos' do
      create(:admin, status: :active)
      create(:currency)
      create(:client_wallet, balance: 10)
      params_content = { transaction: { registered_number: '', value: '' } }
      post '/api/v1/transactions', params: params_content

      expect(response).to have_http_status(:precondition_failed)
      expect(response.body).to include('Número de Registro não pode ficar em branco')
      expect(response.body).to include('Número de Registro não é válido')
    end
  end

  context 'e faz débito na carteira do cliente' do
    it 'com sucesso' do
      create(:admin, status: :active)
      create(:currency)
      create(:client_wallet, balance: 1000)
      params_content = { transaction: { registered_number: '111.111.111-11', value: 100 } }
      post '/api/v1/transactions', params: params_content

      expect(response).to have_http_status(:created)
      expect(response.content_type).to include 'application/json'
      expect(ClientWallet.last.balance).to eq(910)
    end

    it 'e fica pendente de aceite' do
      create(:admin, status: :active)
      create(:currency)
      create(:client_wallet, balance: 1000)
      params_content = { transaction: { registered_number: '111.111.111-11', value: 1001 } }
      post '/api/v1/transactions', params: params_content
      transaction = Transaction.first

      expect(response).to have_http_status(:created)
      expect(transaction.pending?).to be true
    end
  end

  context 'e cashback é adicionado na carteira' do
    it 'com sucesso' do
      create(:admin, status: :active)
      create(:currency)
      create(:client_wallet, balance: 1000)

      params_content = { transaction: { registered_number: '111.111.111-11', value: 1000, cashback: 30 } }
      post '/api/v1/transactions', params: params_content

      expect(response).to have_http_status(:created)
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response['message']).to include 'Transação realizada com sucesso!'
      expect(ClientWallet.last.balance).to eq(130)
    end
  end
end