require 'rails_helper'

describe 'Wallet Client API' do
  context 'POST /api/v1/client_wallets' do
    it 'success' do
      wallet_params = { client_wallet: { registered_number: '111.111.222-98', email: 'teste@gmail.com' } }
      post '/api/v1/client_wallets', params: wallet_params
      expect(response).to have_http_status(:created)
      expect(response.content_type).to include('application/json')
      json_response = JSON.parse(response.body)
      expect(json_response["registered_number"]).to eq('111.111.222-98')
      expect(json_response["email"]).to eq('teste@gmail.com')
    end
  end
end