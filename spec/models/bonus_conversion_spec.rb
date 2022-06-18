require 'rails_helper'

RSpec.describe BonusConversion, type: :model do
  describe '.valid?' do
    context 'presence' do
      it 'inválido quando a data inicial não é informada' do
        create(:admin, status: :active)
        bonus = described_class.new(initial_date: '', final_date: Time.zone.today + 10.days, percentage: 10,
                                    deadline: 20, admin: Admin.first)

        expect(bonus.valid?).to be false
      end

      it 'inválido quando a data final não é informada' do
        create(:admin, status: :active)
        bonus = described_class.new(initial_date: Time.zone.today, final_date: '', percentage: 10,
                                    deadline: 20, admin: Admin.first)

        expect(bonus.valid?).to be false
      end

      it 'inválido quando o percentual não é informado' do
        create(:admin, status: :active)
        bonus = described_class.new(initial_date: Time.zone.today, final_date: Time.zone.today + 10.days,
                                    percentage: '', deadline: 20, admin: Admin.first)

        expect(bonus.valid?).to be false
      end

      it 'inválido quando o prazo para uso não é informada' do
        create(:admin, status: :active)
        bonus = described_class.new(initial_date: Time.zone.today, final_date: Time.zone.today + 10.days,
                                    percentage: 10, deadline: '', admin: Admin.first)

        expect(bonus.valid?).to be false
      end
    end

    context 'comparison' do
      it 'inválido quando data final é anterior à data inicial' do
        create(:admin, status: :active)
        bonus = described_class.new(initial_date: Time.zone.today + 10.days, final_date: Time.zone.today,
                                    percentage: 10, deadline: 10, admin: Admin.first)

        expect(bonus.valid?).to be false
      end

      it 'inválido quando a data inicial é anterior ao dia em que está sendo registrada' do
        create(:admin, status: :active)
        bonus = described_class.new(initial_date: Time.zone.today - 10.days, final_date: Time.zone.today,
                                    percentage: 10, deadline: 10, admin: Admin.first)

        expect(bonus.valid?).to be false
      end
    end

    context 'numericality' do
      it 'inválido quando o prazo de validade não é um número válido' do
        create(:admin, status: :active)
        bonus = described_class.new(initial_date: Time.zone.today, final_date: Time.zone.today + 10.days,
                                    percentage: 10, deadline: -10, admin: Admin.first)

        expect(bonus.valid?).to be false
      end
    end
  end
end
