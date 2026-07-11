# frozen_string_literal: true

# Módulo responsável por formatar erros da API no padrão FleetMaster Logistics.
# Retorna um Hash padronizado: { status: { code: X, message: '...' }, errors: { field: ['msg'] } }
module ApiErrorFormatter
  # Formata um erro para resposta JSON.
  #
  # @param status_code [Symbol, Integer] O status HTTP (ex: :unauthorized ou 401)
  # @param message [String] Mensagem principal do erro
  # @param errors [ActiveModel::Errors, Hash, Array, String, nil] Detalhes dos erros
  #
  # @return [Hash] Resposta padronizada
  def self.format(status_code, message, errors = nil)
    {
      status: {
        code: resolve_status_code(status_code),
        message: message
      },
      errors: format_errors(errors)
    }
  end

  def self.resolve_status_code(status_code)
    status_code.is_a?(Symbol) ? Rack::Utils.status_code(status_code) : status_code.to_i
  end
  private_class_method :resolve_status_code

  def self.format_errors(errors)
    case errors
    when ActiveModel::Errors then errors.as_json
    when Hash then errors.transform_values { |v| Array(v) }
    when Array then { base: errors }
    when NilClass, FalseClass then {}
    else { base: [errors.to_s] }
    end
  end
  private_class_method :format_errors
end
