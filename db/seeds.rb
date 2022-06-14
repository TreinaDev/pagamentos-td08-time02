# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

Admin.create(name: 'Fulano da Silva', password: '12345678', email: 'admin@userubis.com.br',
             registration_number: '123.456.789-00', status: :active)
Admin.create(name: 'Beltrano da Silva', password: '12345678', email: 'admin2@userubis.com.br',
             registration_number: '321.456.789-00', status: :active)
