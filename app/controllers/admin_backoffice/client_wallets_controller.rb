class AdminBackoffice::ClientWalletsController < ApplicationController
  def index
    @client_wallets = ClientWallet.all 
  end

  def show
    @client_wallet = ClientWallet.find(params[:id])
    @categories = Category.all
  end

  def update
    @client_wallet = ClientWallet.find(params[:id])
    category_param = params.require(:client_wallet).permit(:category)
    category = Category.find_by(id: category_param[:category])
    if @client_wallet.update(category: category)
      redirect_to admin_backoffice_client_wallets_path, notice: 'Categoria alterada com sucesso.'
    end
  end
end