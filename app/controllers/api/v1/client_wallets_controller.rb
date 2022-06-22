class Api::V1::ClientWalletsController < Api::V1::ApiController
  def create
    client_wallet = ClientWallet.new(client_wallet_params)
    if client_wallet.save
        render status: 201, json: client_wallet
    else
        render status: 412, json: client_wallet.errors.full_messages
    end
  end

  def balance
    client_wallet = ClientWallet.find_by(registered_number: wallet_registered_number_params[:registered_number]) 
    raise ActiveRecord::RecordNotFound if client_wallet.nil?
    render status: 200, json: client_wallet.as_json(except: [:category, :email])
  end

  private

  def client_wallet_params
    params.require(:client_wallet).permit(:registered_number, :email)
  end

  def wallet_registered_number_params
    params.require(:client_wallet).permit(:registered_number)
  end
end