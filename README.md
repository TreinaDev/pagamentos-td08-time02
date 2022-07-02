# README

## Como utilizar o aplicativo localmente

<p>Com o terminal aberto basta executar as instruções abaixo:</p>

<dl>
  <dt>Faça o clone do código para a pasta que desejar com o comando:</dt>
  <dd>git clone git@github.com:TreinaDev/pagamentos-td08-time02.git</dd>
  
  <dt>Acesse a pasta do aplicativo com 'cd pagamentos-td08-time02' e executando o comando:</dt>
  <dd>bundle install</dd>

  <dt>Para utilizar os exemplos já criados basta executar os comandos:</dt>
  <dd>rails db:migration</dd>
  <dd>rails db:seed</dd>
</dl>

<p>Com isso feito você pode rodar o servidor executando o comando 'rails s'</p>

<dl>
  <dt>Para utilizar o aplicativo você pode logar na aplicação com um administrador padrão</dt>
  <dd>E-mail: <em>admin@userubis.com.br</em></dd>
  <dd>Senha: <em>password</em></dd>
</dl>

## Gems Utilizadas
<ul>
  <li>gem 'bootstrap', '~> 5.1.3'</li>
  <li>gem "sassc-rails"</li>
  <li>gem 'faraday'</li>
  <li>gem 'rubocop'</li>
  <li>gem 'rspec'</li>
  <li>gem 'capybara'</li>
  <li>gem 'shoulda-matchers'</li>
  <li>gem 'factory_bot_rails'</li>
  <li>gem 'simplecov'</li>
</ul>