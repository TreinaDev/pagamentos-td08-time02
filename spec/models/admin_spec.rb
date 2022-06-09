require 'rails_helper'

RSpec.describe Admin, type: :model do
  describe '#valid?' do
    context 'presence' do
      it 'inválido quando nome não for informado' do
        admin = Admin.new(email: 'admin@userubis.com.br', registration_number: '000.000.222-12', name: '',
                          password: '12345678')

        expect(admin.valid?).to eq false
      end

      it 'inválido quando email não for informado' do
        admin = Admin.new(email: '', registration_number: '000.000.222-12', name: 'Admin de Solsa',
                          password: '12345678')

        expect(admin.valid?).to eq false
      end

      it 'inválido quando CPF não for informado' do
        admin = Admin.new(email: 'admin@userubis.com.br', registration_number: '', name: 'Admin de Solsa',
                          password: '12345678')

        expect(admin.valid?).to eq false
      end

      it 'inválido quando CPF não for informado' do
        admin = Admin.new(email: 'admin@userubis.com.br', registration_number: '000.000.222-12',
                          name: 'Admin de Solsa', password: '')

        expect(admin.valid?).to eq false
      end
    end

    context 'format' do
      it "inválido quando o domínio do email não for 'userubis.com.br'" do
        admin = Admin.new(email: 'admin@email.com.br', registration_number: '000-000-000-22',
                          name: 'Admin de Solsa', password: '12345678')

        expect(admin.valid?).to eq false
      end

      it 'inválido quando o CPF estiver no formato incorreto' do
        admin = Admin.new(email: 'admin@userubis.com.br', registration_number: '000-0001-0004-2233',
                          name: 'Admin de Solsa', password: '12345678')

        expect(admin.valid?).to eq false
      end

      it 'O CPF é cadastrado sem os caracteres especiais' do
        admin = Admin.create!(email: 'admin@userubis.com.br', registration_number: '000.000.000-22',
                              name: 'Admin de Solsa', password: '12345678')

        expect(admin.registration_number).to eq '00000000022'
      end
    end

    context 'senha' do
      it 'inválido quando a senha possui menos que oito caracteres' do
        admin = Admin.new(email: 'admin@userubis.com.br', registration_number: '000.000.000-22',
                          name: 'Admin de Solsa', password: '1234567')

        expect(admin.valid?).to eq false
      end
    end

    context 'status do administrador' do
      it 'administrador nasce com status inválido' do
        admin = Admin.new(email: 'admin@userubis.com.br', registration_number: '000.000.000-22',
                          name: 'Admin de Solsa', password: '12345678')

        expect(admin.status).to eq 'innactive'
      end
    end
  end
end
