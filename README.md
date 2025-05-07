
# Kobana Ruby gem

Gem não-oficial em Ruby para integração com a API da Kobana (https://www.kobana.com.br),  
com suporte à criação de pagamentos via Pix, validações locais e tratamento de erros.

⚠️ **Esta gem ainda NÃO está publicada no RubyGems.org.**  
As instruções abaixo mostram como instalá-la e usá-la localmente.

---

## INSTALAÇÃO LOCAL

1. Clone o repositório:
   ```bash
   git clone https://github.com/seu-usuario/kobana.git
   cd kobana
   ```

2. Construa a gem:
   ```bash
   gem build kobana.gemspec
   ```

3. Instale localmente:
   ```bash
   gem install ./kobana-0.1.0.gem
   ```

4. Ou adicione no seu Gemfile:
   ```ruby
   gem "kobana", path: "/caminho/absoluto/para/kobana"
   ```

---

## CONFIGURAÇÃO

Antes de fazer qualquer chamada à API, configure a gem:

```ruby
require "kobana"

Kobana.use_sandbox = true # opcional
Kobana.token = "SEU_TOKEN_AQUI"
Kobana.user_agent = "Seu Nome <seu@email.com>"
Kobana.max_network_retries = 2
Kobana.timeout = 60
Kobana.open_timeout = 30
Kobana.log_level = Kobana::LEVEL_INFO
```

---

## EXEMPLO: PAGAMENTO VIA PIX

```ruby
params = {
  amount: "100", # em centavos (R$1,00 = "100")
  financial_account_uid: "uuid-da-conta",
  qrcode: "6052022"
}

begin
  response = Kobana::Resources::PixPayment.create(params)
  puts response
rescue Kobana::ApiError => e
  puts "Erro na API (status #{e.status_code}): #{e.message}"
  puts "Resposta da API: #{e.response}"
end
```

---

## VALIDAÇÃO LOCAL

```ruby
begin
  Kobana::Validations::PixPaymentValidator.validate!(params)
rescue Kobana::ValidationError => e
  puts "Erros de validação: #{e.errors}"
end
```

---

## TRATAMENTO DE ERROS

A gem define erros específicos:

- `Kobana::ApiError` – Respostas 4xx da API
- `Kobana::ServerError` – Respostas 5xx
- `Kobana::RateLimitError` – Excedeu o limite de requisições (429)
- `Kobana::ValidationError` – Validação local falhou
- `Kobana::KobanaError` – Qualquer outro erro inesperado

---

## TESTES E ANÁLISE ESTÁTICA

Para rodar os testes e o RuboCop:

```bash
bundle install
bundle exec rspec
bundle exec rubocop
```

---

## CONTRIBUINDO

1. Faça um fork
2. Crie uma branch:
   ```bash
   git checkout -b minha-feature
   ```
3. Commit:
   ```bash
   git commit -m 'Minha contribuição'
   ```
4. Push:
   ```bash
   git push origin minha-feature
   ```
5. Abra um Pull Request

---

## LICENÇA

MIT © 2025 Gabriel Rocha
