require 'rails_helper'

describe 'Wallet Client API' do
  context 'POST /api/v1/client_wallets' do
    it 'com sucesso' do
      wallet_params = { client_wallet: { registered_number: '111.111.222-98', email: 'teste@gmail.com' } }
      post '/api/v1/client_wallets', params: wallet_params
      expect(response).to have_http_status(:created)
      expect(response.content_type).to include('application/json')
      json_response = JSON.parse(response.body)
      expect(json_response['registered_number']).to eq('111.111.222-98')
      expect(json_response['email']).to eq('teste@gmail.com')
    end

    it 'falha com dados incompletos' do
      wallet_params = { client_wallet: { registered_number: '111.222.333-444' } }
      post '/api/v1/client_wallets', params: wallet_params

      expect(response).to have_http_status(:precondition_failed)
      expect(response.body).to include 'E-mail não pode ficar em branco'
      expect(response.body).to include 'CPF ou CNPJ não é válido'
    end

    it 'com um cliente que já existe' do
      create(:client_wallet, email: 'teste@email.com')
      wallet_params = { client_wallet: { registered_number: '111.111.111-11', email: 'teste@email.com' } }

      post '/api/v1/client_wallets', params: wallet_params

      expect(response).to have_http_status(412)
      expect(response.body).to include 'E-mail já está em uso'
      expect(response.body).to include 'CPF ou CNPJ já está em uso'
    end

  end

  context 'GET /api/v1/client_wallet/balance' do
    it 'com sucesso' do
      client_wallet = create(:client_wallet)
      wallet_params = { client_wallet: { registered_number: client_wallet.registered_number.to_s } }

      get '/api/v1/client_wallet/balance', params: wallet_params

      expect(response).to have_http_status(:ok)
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response['registered_number']).to eq('111.111.111-11')
      expect(json_response['balance']).to eq(10)
      expect(json_response['bonus_balance']).to eq(0)
      expect(json_response).not_to include('email')
      expect(json_response).not_to include('category')
    end

    it 'com dados inválidos e falha' do
      wallet_params = { client_wallet: { registered_number: '4848' } }
      get '/api/v1/client_wallet/balance', params: wallet_params

      expect(response).to have_http_status(:not_found)
    end
  end
end
