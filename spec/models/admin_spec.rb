require 'rails_helper'

RSpec.describe Admin, type: :model do
  describe '#valid?' do
    context 'presence' do
      it 'inválido quando nome não for informado' do
        expect(described_class.new).to validate_presence_of(:name)
      end

      it 'inválido quando email não for informado' do
        expect(described_class.new).to validate_presence_of(:email)
      end

      it 'inválido quando CPF não for informado' do
        expect(described_class.new).to validate_presence_of(:registration_number)
      end

      it 'inválido quando senha não for informado' do
        expect(described_class.new).to validate_presence_of(:password)
      end
    end

    context 'format' do
      it "inválido quando o domínio do email não for 'userubis.com.br'" do
        admin = described_class.new

        expect(admin).to allow_value('admin@userubis.com.br').for(:email)
        expect(admin).not_to allow_value('admin@gmail.com.br').for(:email)
      end

      it 'inválido quando o CPF estiver no formato incorreto' do
        admin = described_class.new

        expect(admin).to allow_value('111.222.333-44').for(:registration_number)
        expect(admin).not_to allow_value('1111.2222.333.4').for(:registration_number)
      end

      it 'O CPF é cadastrado sem os caracteres especiais' do
        admin = create(:admin)

        expect(admin.registration_number).to eq '11122233344'
      end
    end

    context 'status do administrador' do
      it 'administrador nasce com status inválido' do
        admin = build(:admin)

        expect(admin.status).to eq 'inactive'
      end
    end

    context 'uniqueness' do
      it 'inválido quando o CPF já está cadastrado' do
        create(:admin, registration_number: '111.222.333-44')

        admin = described_class.new(name: 'Cicrano da Silva', registration_number: '11122233344',
                                    email: 'admin5@userubis.com.br', password: '12345678')

        expect(admin.valid?).to be false
      end
    end
  end
end
