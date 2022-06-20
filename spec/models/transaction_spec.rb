require 'rails_helper'

RSpec.describe Transaction, type: :model do
  describe '.valid?' do
    context 'presence' do
      it 'Inválido quando valor é nulo' do
        transaction = described_class.new(value: '', registered_number: '111.111.111-11', status: :accepted,
                                          transaction_type: :debit, currency_rate: 1.5)

        expect(transaction.valid?).to be false
      end

      it 'Inválido quando taxa de câmbio é nulo' do
        transaction = described_class.new(value: 1000, registered_number: '111.111.111-11', status: :accepted,
                                          transaction_type: :debit, currency_rate: '')

        expect(transaction.valid?).to be false
      end

      it 'Inválido quando número de registro é nulo' do
        transaction = described_class.new(value: 1000, registered_number: '', status: :accepted,
                                          transaction_type: :debit, currency_rate: 1.5)

        expect(transaction.valid?).to be false
      end
    end

    context 'numericality' do
      it 'Inválido quando valor é menor que um' do
        transaction = described_class.new(value: 0, registered_number: '111.111.111-11', status: :accepted,
                                          transaction_type: :debit, currency_rate: 1.5)

        expect(transaction.valid?).to be false
      end

      it 'Inválido quando taxa de câmbio é menor ou igual a zero' do
        transaction = described_class.new(value: 10, registered_number: '111.111.111-11', status: :accepted,
                                          transaction_type: :debit, currency_rate: 0)

        expect(transaction.valid?).to be false
      end
    end

    context 'format' do
      it 'Inválido quando formato do número do registro' do
        transaction = described_class.new(value: 100, registered_number: '114444.111-11', status: :accepted,
                                          transaction_type: :debit, currency_rate: 1.5)

        expect(transaction.valid?).to be false
      end
    end
  end
end
