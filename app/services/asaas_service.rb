# frozen_string_literal: true

require 'net/http'
require 'json'
require 'uri'

# Serviço de integração com o gateway de pagamentos Asaas (API v3).
# Suporta criação de clientes, emissão de cobranças (PIX, Boleto, Cartão) e consulta de QR Code.
# Em ambiente de teste ou quando a chave não estiver configurada, simula as respostas para estabilidade total.
class AsaasService
  SANDBOX_URL = 'https://sandbox.asaas.com/api/v3'
  PRODUCTION_URL = 'https://api.asaas.com/v3'

  def initialize(api_key = nil, environment = nil)
    @api_key = api_key || ENV['ASAAS_API_KEY'] || 'simulated_key'
    @base_url = (environment == 'production' || Rails.env.production?) ? PRODUCTION_URL : SANDBOX_URL
  end

  # Cria ou localiza um cliente no Asaas.
  #
  # @param name [String] Nome do cliente ou razão social
  # @param email [String] E-mail
  # @param cpf_cnpj [String] Documento CPF ou CNPJ
  # @param phone [String, nil] Telefone
  # @return [Hash] Dados do cliente no Asaas (contendo 'id')
  def find_or_create_customer(name:, email:, cpf_cnpj: nil, phone: nil)
    return simulated_customer(name, email, cpf_cnpj) if mock_mode?

    # Busca existente pelo CPF/CNPJ ou e-mail
    if cpf_cnpj.present?
      existing = get('/customers', { cpfCnpj: cpf_cnpj.gsub(/\D/, '') })
      return existing['data'].first if existing['data']&.any?
    end

    post('/customers', {
      name: name,
      email: email,
      cpfCnpj: cpf_cnpj&.gsub(/\D/, ''),
      phone: phone&.gsub(/\D/, '')
    }.compact)
  end

  # Cria uma cobrança avulsa no Asaas.
  #
  # @param customer_id [String] ID do cliente retornado pelo Asaas
  # @param billing_type [String] 'PIX', 'BOLETO' ou 'CREDIT_CARD'
  # @param value [Numeric] Valor da cobrança
  # @param due_date [Date, String] Data de vencimento
  # @param description [String] Descrição
  # @return [Hash] Dados da cobrança no Asaas
  def create_charge(customer_id:, billing_type:, value:, due_date:, description: nil)
    return simulated_charge(customer_id, billing_type, value, due_date, description) if mock_mode?

    post('/payments', {
      customer: customer_id,
      billingType: billing_type.to_s.upcase,
      value: value.to_f,
      dueDate: due_date.to_s,
      description: description
    }.compact)
  end

  # Obtém o QR Code e linha digitável do PIX para uma cobrança.
  #
  # @param payment_id [String] ID da cobrança no Asaas
  # @return [Hash] Contendo 'encodedImage' (base64) e 'payload' (copia e cola)
  def get_pix_qr_code(payment_id)
    return simulated_pix_qr_code if mock_mode?

    get("/payments/#{payment_id}/pixQrCode")
  end

  private

  def mock_mode?
    @api_key == 'simulated_key' || Rails.env.test?
  end

  def get(endpoint, params = {})
    uri = URI("#{@base_url}#{endpoint}")
    uri.query = URI.encode_www_form(params) if params.any?

    request = Net::HTTP::Get.new(uri)
    execute(uri, request)
  end

  def post(endpoint, body = {})
    uri = URI("#{@base_url}#{endpoint}")
    request = Net::HTTP::Post.new(uri)
    request.body = body.to_json
    execute(uri, request)
  end

  def execute(uri, request)
    request['access_token'] = @api_key
    request['Content-Type'] = 'application/json'

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https', open_timeout: 10, read_timeout: 15) do |http|
      http.request(request)
    end

    JSON.parse(response.body)
  rescue StandardError => e
    Rails.logger.error("[AsaasService] Falha na comunicação HTTP com Asaas: #{e.message}")
    { 'error' => e.message }
  end

  # Mocks elegantes para testes e dev sem chave real configurada
  def simulated_customer(name, email, cpf_cnpj)
    {
      'id' => "cus_#{SecureRandom.hex(8)}",
      'name' => name,
      'email' => email,
      'cpfCnpj' => cpf_cnpj
    }
  end

  def simulated_charge(customer_id, billing_type, value, due_date, description)
    id = "pay_#{SecureRandom.hex(8)}"
    {
      'id' => id,
      'customer' => customer_id,
      'billingType' => billing_type.to_s.upcase,
      'value' => value.to_f,
      'netValue' => (value.to_f * 0.98).round(2),
      'status' => 'PENDING',
      'dueDate' => due_date.to_s,
      'invoiceUrl' => "https://sandbox.asaas.com/i/#{id}",
      'bankSlipUrl' => "https://sandbox.asaas.com/b/pdf/#{id}",
      'description' => description
    }
  end

  def simulated_pix_qr_code
    {
      'encodedImage' => 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNk+M9QDwADhgGAWjR9awAAAABJRU5ErkJggg==',
      'payload' => '00020126580014br.gov.bcb.pix0136123e4567-e89b-12d3-a456-4266141740005204000053039865802BR5913FleetMaster6008Recife62070503***6304E2CA'
    }
  end
end
