require 'rails_helper'

RSpec.describe Transaction, type: :model do
  describe '.valid?' do
    context 'presence' do
      it 'Inválido quando valor é nulo' do
        transaction = described_class.new(value: '', registered_number: '111.111.111-11', status: :accepted,
                                          transaction_type: :debit, currency_rate: 1.5, order: 1)

        expect(transaction.valid?).to be false
      end

      it 'Inválido quando taxa de câmbio é nulo' do
        transaction = described_class.new(value: 1000, registered_number: '111.111.111-11', status: :accepted,
                                          transaction_type: :debit, currency_rate: '', order: 1)

        expect(transaction.valid?).to be false
      end

      it 'Inválido quando número de registro é nulo' do
        transaction = described_class.new(value: 1000, registered_number: '', status: :accepted,
                                          transaction_type: :debit, currency_rate: 1.5, order: 1)

        expect(transaction.valid?).to be false
      end

      it 'Inválido quando id do pedido é nulo' do
        transaction = described_class.new(value: 1000, registered_number: '111.111.111-11', status: :accepted,
                                          transaction_type: :debit, currency_rate: 1.5, order: '')

        expect(transaction.valid?).to be false
      end
    end

    context 'numericality' do
      it 'Inválido quando valor é menor que um' do
        transaction = described_class.new(value: 0, registered_number: '111.111.111-11', status: :accepted,
                                          transaction_type: :debit, currency_rate: 1.5, order: 1)

        expect(transaction.valid?).to be false
      end

      it 'Inválido quando taxa de câmbio é menor ou igual a zero' do
        transaction = described_class.new(value: 10, registered_number: '111.111.111-11',
                                          status: :accepted, currency_rate: 0, order: 1)

        expect(transaction.valid?).to be false
      end

      it 'Inválido quando cashback é menor que zero' do
        transaction = described_class.new(value: 100, registered_number: '114444.111-11', status: :accepted,
                                          status: :accepted, cashback: -1, currency_rate: 1.5, order: 1)

        expect(transaction.valid?).to be false
      end
    end

    context 'uniqueness' do
      it 'Inválido quando order já está em uso' do
        create(:client_wallet)
        create(:transaction)
        transaction = described_class.new(value: 1500, registered_number: '222.111.111-11',
                                          currency_rate: 1.5, order: 1)

        expect(transaction.valid?).to be false
      end
    end

    context 'format' do
      it 'Inválido quando formato do número do registro' do
        transaction = described_class.new(value: 100, registered_number: '114444.111-11', status: :accepted,
                                          transaction_type: :debit, currency_rate: 1.5, order: 1)

        expect(transaction.valid?).to be false
      end
    end
  end
end
