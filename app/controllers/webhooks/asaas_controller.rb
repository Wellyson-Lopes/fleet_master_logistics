# frozen_string_literal: true

module Webhooks
  # Endpoint responsável por receber notificações assíncronas do Asaas (Webhooks).
  # Atualiza o status de cobranças (PIX recebido, boleto compensado, etc.) e libera serviços/assinaturas.
  class AsaasController < ActionController::API
    def receive
      event = params[:event]
      payment_data = params[:payment] || {}
      asaas_id = payment_data[:id]

      charge = AsaasCharge.find_by(asaas_id: asaas_id)

      if charge.nil?
        render json: { status: 'ignored', message: 'Cobrança não localizada localmente.' }, status: :ok
        return
      end

      case event
      when 'PAYMENT_RECEIVED', 'PAYMENT_CONFIRMED'
        charge.update(
          status: 'RECEIVED',
          payment_date: payment_data[:paymentDate] || Time.current,
          net_value: payment_data[:netValue]
        )

        # Se a cobrança for para um plano de assinatura da Empresa, ativa o status
        if charge.payable.is_a?(Company)
          charge.payable.update(subscription_status: 'active', trial_ends_at: nil)
        elsif charge.payable.is_a?(MachineryRental)
          charge.payable.update(notes: "#{charge.payable.notes}\n[Pagamento Asaas Confirmado em #{Time.current}]".strip)
        end

      when 'PAYMENT_OVERDUE'
        charge.update(status: 'OVERDUE')
      when 'PAYMENT_REFUNDED'
        charge.update(status: 'REFUNDED')
      end

      render json: { status: 'processed', event: event, charge_id: charge.id }, status: :ok
    end
  end
end
