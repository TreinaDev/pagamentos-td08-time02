require 'rails_helper'

RSpec.describe Currency, type: :model do
  describe '#valid?' do
    context 'presence' do
      it 'inválido quando currency_value não for informado' do
        expect(described_class.new).to validate_presence_of(:currency_value)
      end
    end

    context 'format' do
      it 'inválido quando currency_value for menor igual a zero ou for uma letra' do
        currency = described_class.new

        expect(currency).to allow_value(1.5).for(:currency_value)
        expect(currency).not_to allow_value(0).for(:currency_value)
        expect(currency).not_to allow_value('a').for(:currency_value)
      end
    end
  end
end
