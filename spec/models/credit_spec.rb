require 'rails_helper'

RSpec.describe Credit, type: :model do
  describe '#valid?' do
    context 'presence' do
      it 'inválido quando value estiver em branco' do
        expect(described_class.new).to validate_presence_of(:value)
      end

      it 'inválido quando client_wallet estiver vazio' do
        expect(subject).to belong_to(:client_wallet)
      end

      it 'inválido quando value não for número' do
        credit = described_class.new

        expect(credit).to allow_value(5).for(:value)
        expect(credit).not_to allow_value(-5).for(:value)
        expect(credit).not_to allow_value('aaa').for(:value)
      end
    end
  end

  describe '#check_for_bonus_conversion' do
    it 'adiciona saldo bônus caso haja conversão bônus' do
      bonus_conversion = create(:bonus_conversion, percentage: 10)
      create(:currency)
      category = create(:category, bonus_conversion:)
      client_wallet = create(:client_wallet, category:)
      create(:credit, bonus_conversion:, client_wallet:)

      client_wallet.reload
      expect(client_wallet.balance).to eq(6676)
      expect(client_wallet.bonus_balance).to eq(666)
    end
  end
end
