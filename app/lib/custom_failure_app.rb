# frozen_string_literal: true

# Customização da resposta de falha de autenticação do Devise.
# Garante que requisições de API recebam uma resposta JSON 401 em vez de redirecionamento.
class CustomFailureApp < Devise::FailureApp
  # Define a URL de redirecionamento para falhas em ambiente Web.
  #
  # @return [String] Caminho raiz
  def redirect_url
    root_path
  end

  # Decide como responder à falha (JSON para API, Redirect para Web).
  #
  # @return [void]
  def respond
    if request.format.json? || request.path.start_with?('/api/')
      json_error_response
    elsif http_auth?
      http_auth
    else
      redirect
    end
  end

  private

  # Renderiza a resposta de erro customizada para API.
  #
  # @return [void]
  def json_error_response
    self.status = 401
    self.content_type = 'application/json'
    self.response_body = ApiErrorFormatter.format(401, 'Não autorizado. Verifique suas credenciais ou token.').to_json
  end
end
