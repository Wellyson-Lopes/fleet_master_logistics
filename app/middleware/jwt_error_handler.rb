# frozen_string_literal: true

# Middleware responsável por capturar erros de decodificação e validação de tokens JWT.
# Evita que exceções do JWT resultem em erro 500, retornando uma resposta 401 padronizada.
class JwtErrorHandler
  # Inicializa o middleware.
  #
  # @param app [Rack Application] A aplicação Rack
  def initialize(app)
    @app = app
  end

  # Processa a requisição e captura exceções relacionadas ao JWT.
  #
  # @param env [Hash] O ambiente Rack
  #
  # @return [Array] Resposta Rack (status, headers, body)
  def call(env)
    @app.call(env)
  rescue JWT::DecodeError, JWT::VerificationError, JWT::Base64DecodeError => e
    Rails.logger.error "JWT Error: #{e.message}"
    [
      401,
      { 'Content-Type' => 'application/json' },
      [{ status: { code: 401, message: "Token inválido ou expirado: #{e.message}" } }.to_json]
    ]
  end
end
