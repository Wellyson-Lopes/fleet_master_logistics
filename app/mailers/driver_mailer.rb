# frozen_string_literal: true

# Mailer responsável pelo envio de comunicações diretas aos motoristas da frota.
class DriverMailer < ApplicationMailer
  default from: 'no-reply@fleetmaster.com.br'

  # Envia o código de convite de 6 dígitos para o primeiro acesso do motorista.
  #
  # @param driver [Driver] Motorista que está sendo convidado
  def invite_with_code(driver)
    @driver = driver
    @company = driver.company
    @code = driver.invitation_code

    mail(
      to: @driver.email,
      subject: "🚛 Bem-vindo ao FleetMaster - Seu código de acesso é #{@code}"
    )
  end

  # Notifica o motorista sobre uma nova viagem / entrega atribuída a ele.
  #
  # @param driver [Driver] Motorista designado
  # @param trip [Trip] Viagem criada
  def trip_assigned(driver, trip)
    @driver = driver
    @trip = trip
    @company = driver.company

    mail(
      to: @driver.email,
      subject: "📦 Nova Viagem Atribuída: #{@trip.code} (#{@trip.destination})"
    )
  end

  # Alerta o motorista sobre documento próximo do vencimento ou vencido.
  #
  # @param driver [Driver] Motorista notificado
  # @param title [String] Título do alerta
  # @param message [String] Mensagem explicativa
  def document_alert(driver, title, message)
    @driver = driver
    @title = title
    @message = message

    mail(
      to: @driver.email,
      subject: "⚠️ Alerta FleetMaster: #{@title}"
    )
  end
end
