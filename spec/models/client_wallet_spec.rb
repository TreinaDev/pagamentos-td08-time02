require 'rails_helper'

RSpec.describe ClientWallet, type: :model do
  describe '#valid?' do
    context 'presence' do
      it 'inválido quando CPF ou CNPJ estiver vazio' do
        expect(described_class.new).to validate_presence_of(:registered_number)
      end

      it 'inválido quando email estiver vazio' do
        expect(described_class.new).to validate_presence_of(:email)
      end

      it 'inválido quando saldo estiver vazio' do
        expect(described_class.new).to validate_presence_of(:balance)
      end

      it 'inválido quando saldo bonus estiver vazio' do
        expect(described_class.new).to validate_presence_of(:bonus_balance)
      end
    end

    context 'format' do
      it 'saldo e saldo bonus precisa ser inteiro' do
        expect(described_class.new).to validate_numericality_of(:balance).only_integer
        expect(described_class.new).to validate_numericality_of(:bonus_balance).only_integer
      end

      it 'saldo e saldo bonus precisa ser maior ou igual a 0' do
        expect(described_class.new).to validate_numericality_of(:balance).is_greater_than_or_equal_to(0)
        expect(described_class.new).to validate_numericality_of(:bonus_balance).is_greater_than_or_equal_to(0)
      end

      it 'email tem que ser um email válido' do
        expect(described_class.new).to allow_value('admin@userubis.com.br').for(:email)
        expect(described_class.new).to allow_value('admin@userubis.com').for(:email)
        expect(described_class.new).to allow_value('user@teste.com').for(:email)
        expect(described_class.new).to allow_value('user@email.com.br').for(:email)
        expect(described_class.new).not_to allow_value('@').for(:email)
        expect(described_class.new).not_to allow_value('aaaaaa@').for(:email)
      end

      it 'deve ter CPF ou CNPJ válido' do
        expect(described_class.new).to allow_value('111.222.333-44').for(:registered_number)
        expect(described_class.new).to allow_value('74.296.180/0001-37').for(:registered_number)
        expect(described_class.new).not_to allow_value('1111.222.333-44').for(:registered_number)
        expect(described_class.new).not_to allow_value('74.296.180/0001-').for(:registered_number)

      end
    end
  end
end
