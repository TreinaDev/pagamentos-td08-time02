require 'rails_helper'

RSpec.describe CreditLimit, type: :model do
  describe '#valid' do
    it 'validates presence of max_limit' do
      expect(described_class.new).to validate_presence_of(:max_limit)
    end

    it 'validates numericality of max_limit' do
      expect(described_class.new).to validate_numericality_of(:max_limit)
      expect(described_class.new).not_to allow_value(-5).for(:max_limit)
      expect(described_class.new).not_to allow_value('aa').for(:max_limit)
    end
  end
end
