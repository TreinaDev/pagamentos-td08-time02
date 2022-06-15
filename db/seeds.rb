# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

admin_ativo = Admin.create(name: 'Admin Genérico', email: 'admin@userubis.com.br', password: 'password', registration_number: '111.222.333-44', status: :active)
admin_ativo_2 = Admin.create(name: 'Admin de Marca', email: 'admin2@userubis.com.br', password: 'password', registration_number: '222.442.333-44', status: :active)

