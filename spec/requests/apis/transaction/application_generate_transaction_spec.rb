require 'rails_helper'

describe 'Aplicação gera uma transação' do
  context 'POST /api/v1/transaction' do
    it 'de débito com sucesso' do
      create(:client_wallet)
      params_content = { transaction: { registered_number: '111.111.111-11', value: 100, currency_rate: 10,
                                        transaction_type: :debit } }
      post '/api/v1/transaction', params: params_content

      expect(response).to have_http_status(:created)
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response['registered_number']).to eq('111.111.111-11')
      expect(json_response['value']).to eq(100)
      expect(json_response['currency_rate']).to eq(10.0)
      expect(json_response['transaction_type']).to eq('debit')
    end

    it 'falha se parametros incompletos' do
      params_content = { transaction: { registered_number: '', value: 100, currency_rate: 10,
                                        transaction_type: :debit } }
      post '/api/v1/transaction', params: params_content

      expect(response).to have_http_status(:precondition_failed)
      expect(response.body).to include('Número de Registro não pode ficar em branco')
      expect(response.body).to include('Número de Registro não é válido')
    end
  end

  context 'e faz débito na carteira do cliente' do
    it 'com sucesso' do
      client_wallet = create(:client_wallet, balance: 1000)
      params_content = { transaction: { registered_number: '111.111.111-11', value: 100, currency_rate: 10,
                                        transaction_type: :debit } }
      post '/api/v1/transaction', params: params_content
      transaction = Transaction.first
      wallet_debited = ClientWallet.find_by(registered_number: transaction.registered_number)

      expect(response).to have_http_status(:created)
      expect(wallet_debited.balance).to eq(client_wallet.balance - transaction.value)
    end

    it 'e fica pendente de aceite' do
      create(:client_wallet, balance: 1000)
      params_content = { transaction: { registered_number: '111.111.111-11', value: 1001, currency_rate: 10,
                                        transaction_type: :debit } }
      post '/api/v1/transaction', params: params_content
      transaction = Transaction.first

      expect(response).to have_http_status(:created)
      expect(transaction.pending?).to be true
    end
  end
end
