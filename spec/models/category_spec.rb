require 'rails_helper'

RSpec.describe Category, type: :model do
  describe '#valid?' do
    context 'presence' do
      it 'inválido quando o nome está em branco' do
        expect(described_class.new).to validate_presence_of(:name)
      end

      it 'inválido quando a taxa de desconto estiver em branco' do
        expect(described_class.new).to validate_presence_of(:discount)
      end
    end

    context 'length' do
      it 'nome tem pelo menos 5 letras' do
        expect(described_class.new).to validate_length_of(:name).is_at_least(3)
      end
    end

    context 'numericality' do
      it 'desconto precisa ser integer e maior ou igual a 0' do
        expect(described_class.new).to validate_numericality_of(:discount).only_integer
        expect(described_class.new).to validate_numericality_of(:discount).is_greater_than_or_equal_to(0)
      end
    end
  end
end
