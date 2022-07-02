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

## Funcionamento da aplicação
<ul>
  <li>Para o registro de um administrador, o email do mesmo deve ser 'nomequalquer@userubis.com.br'</li>
  <li>Para que o novo administrador seja utilizavél, outros dois administradores ativos devem aprovar o cadastro</li>
  <li>O aplicativo obrigatoriamente deve possuir uma Taxa de Câmbio ativa no dia</li>
  <li>Uma Taxa de Câmbio ativa tem um prazo de válidade de 3 dias</li>
  <li>Se uma nova Taxa de Câmbio for dez porcento maior que a anterior ela será pendente de aprovação, e só pode ser aprovada por um admin diferente do que criou a Taxa de Câmbio</li>
  <li>Se uma transação pendente for aprovada, ela não irá gerar movimentação na carteira de cliente, está funcionalidade não foi implementada</li>
</ul>

## Como utilizar a API

<dl>
  <dt>Para acrescentar Rubis a carteira do cliente:</dt>
  <dd><strong>POST</strong>: '/api/v1/credits', params: { credit: { registered_number: '111.111.111-11', value: 1000 } }</dd>
  <dt>Para criar uma carteira de cliente</dt>
  <dd><strong>POST</strong>: '/api/v1/client_wallets', params: { client_wallet: { registered_number: '111.111.111-11', email: 'email@valido.com' } }</dd>
  <dt>Para realizar uma transação</dt>
  <dd><strong>POST</strong>: '/api/v1/transactions', params: { transaction: { registered_number: '111.111.111-11', value: 100, order: 1 } }</dd>
  <dt>Para pegar a Taxa de Câmbio</dt>
  <dd><strong>GET</strong>: '/api/v1/current_rate'</dd>
  <dt>Para pegar um transação expecifica</dt>
  <dd><strong>GET</strong>: "/api/v1/transactions/ código alfanumérico da transação "</dd>
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