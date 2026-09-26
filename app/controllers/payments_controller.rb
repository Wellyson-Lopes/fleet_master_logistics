# frozen_string_literal: true

class PaymentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_charge, only: [:show]

  def index
    @charges = policy_scope(AsaasCharge).includes(:client).order(created_at: :desc)
    @charges = @charges.where(status: params[:status]) if params[:status].present?

    @total_received = @charges.where(status: %w[RECEIVED CONFIRMED]).sum(:value)
    @total_pending = @charges.where(status: 'PENDING').sum(:value)
  end

  def show; end

  def new
    @charge = AsaasCharge.new(
      billing_type: 'PIX',
      value: params[:value] || 100.0,
      due_date: Date.current + 3.days,
      payable_type: params[:payable_type],
      payable_id: params[:payable_id]
    )
    @clients = policy_scope(Client).active.order(:name)
  end

  def create
    @charge = AsaasCharge.new(charge_params)
    @charge.company = current_user.company

    client = policy_scope(Client).find_by(id: params[:asaas_charge][:client_id])
    @charge.client = client

    # Integração com API Asaas
    service = AsaasService.new
    customer = service.find_or_create_customer(
      name: client&.name || current_user.company.name,
      email: client&.email || current_user.email,
      cpf_cnpj: client&.document || current_user.company.cnpj,
      phone: client&.phone
    )

    result = service.create_charge(
      customer_id: customer['id'],
      billing_type: @charge.billing_type,
      value: @charge.value,
      due_date: @charge.due_date,
      description: @charge.description.presence || "Cobrança FleetMaster - #{@charge.payable_type || 'Serviços'}"
    )

    if result['id'].present?
      @charge.asaas_id = result['id']
      @charge.customer_id = customer['id']
      @charge.invoice_url = result['invoiceUrl']
      @charge.bank_slip_url = result['bankSlipUrl']
      @charge.status = result['status'] || 'PENDING'

      # Se for PIX, busca o QR Code
      if @charge.billing_type == 'PIX'
        pix_data = service.get_pix_qr_code(result['id'])
        @charge.pix_qr_code = pix_data['encodedImage']
        @charge.pix_copy_paste = pix_data['payload']
      end

      if @charge.save
        redirect_to payment_path(@charge), notice: "Cobrança #{@charge.billing_type} emitida com sucesso via Asaas!"
      else
        @clients = policy_scope(Client).active.order(:name)
        render :new, status: :unprocessable_entity
      end
    else
      @clients = policy_scope(Client).active.order(:name)
      flash.now[:alert] = "Erro na API Asaas: #{result['error'] || 'Não foi possível gerar a cobrança.'}"
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_charge
    @charge = policy_scope(AsaasCharge).find(params[:id])
  end

  def charge_params
    params.require(:asaas_charge).permit(
      :client_id, :billing_type, :value, :due_date,
      :description, :payable_type, :payable_id
    )
  end
end
