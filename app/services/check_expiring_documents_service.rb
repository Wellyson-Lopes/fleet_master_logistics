# frozen_string_literal: true

# Serviço que audita a frota e os motoristas em busca de CNHs e CRLVs vencidos ou próximos do vencimento,
# gerando notificações in-app para o motorista e alertas no sininho web para secretários e administradores.
class CheckExpiringDocumentsService
  def self.call
    new.call
  end

  def call
    alerts_generated = 0

    # 1. Auditoria de Motoristas (CNH)
    Driver.find_each do |driver|
      next if driver.cnh_expiration.blank?

      Current.company = driver.company

      if driver.cnh_expired?
        alerts_generated += 1 if notify_cnh_expired(driver)
      elsif driver.cnh_expiring_soon?
        alerts_generated += 1 if notify_cnh_expiring_soon(driver)
      end
    end

    # 2. Auditoria de Veículos (CRLV)
    Vehicle.find_each do |vehicle|
      next if vehicle.crlv_expiration.blank?

      Current.company = vehicle.company

      if vehicle.crlv_expired?
        alerts_generated += 1 if notify_crlv_expired(vehicle)
      elsif vehicle.crlv_expiring_soon?
        alerts_generated += 1 if notify_crlv_expiring_soon(vehicle)
      end
    end

    alerts_generated
  end

  private

  def notify_cnh_expired(driver)
    existing = driver.driver_notifications.where(
      notification_type: 'cnh_expired',
      created_at: Time.current.beginning_of_day..Time.current.end_of_day
    ).exists?

    return false if existing

    title = '🚨 CNH Vencida!'
    message = "A Carteira Nacional de Habilitação do motorista #{driver.name} (#{driver.cpf}) venceu em #{I18n.l(driver.cnh_expiration, format: :long)}."

    # Notificação mobile
    driver.driver_notifications.create!(
      company_id: driver.company_id,
      title: title,
      message: message,
      notification_type: 'cnh_expired',
      notifiable: driver
    )

    # Notificação web para secretários/admins
    driver.company.notifications.create!(
      title: title,
      message: message,
      notification_type: 'document_expiring',
      notifiable: driver
    )

    DriverMailer.document_alert(driver, title, message).deliver_later
    true
  end

  def notify_cnh_expiring_soon(driver)
    days_left = (driver.cnh_expiration - Date.current).to_i

    existing = driver.driver_notifications.where(
      notification_type: 'cnh_expiring_soon',
      created_at: 7.days.ago..Time.current
    ).exists?

    return false if existing

    title = "⚠️ CNH Vence em #{days_left} dias"
    message = "A CNH do motorista #{driver.name} vencerá em #{I18n.l(driver.cnh_expiration, format: :long)}. Agende a renovação."

    driver.driver_notifications.create!(
      company_id: driver.company_id,
      title: title,
      message: message,
      notification_type: 'cnh_expiring_soon',
      notifiable: driver
    )

    driver.company.notifications.create!(
      title: title,
      message: message,
      notification_type: 'document_expiring',
      notifiable: driver
    )

    DriverMailer.document_alert(driver, title, message).deliver_later
    true
  end

  def notify_crlv_expired(vehicle)
    existing = vehicle.company.notifications.where(
      notification_type: 'document_expiring',
      notifiable: vehicle,
      created_at: Time.current.beginning_of_day..Time.current.end_of_day
    ).exists?

    return false if existing

    vehicle.company.notifications.create!(
      title: "🚨 CRLV Vencido: Placa #{vehicle.plate}",
      message: "O documento do caminhão #{vehicle.brand} #{vehicle.model} (Placa: #{vehicle.plate}) venceu em #{I18n.l(vehicle.crlv_expiration, format: :long)}.",
      notification_type: 'document_expiring',
      notifiable: vehicle
    )
    true
  end

  def notify_crlv_expiring_soon(vehicle)
    days_left = (vehicle.crlv_expiration - Date.current).to_i

    existing = vehicle.company.notifications.where(
      notification_type: 'document_expiring',
      notifiable: vehicle,
      created_at: 7.days.ago..Time.current
    ).exists?

    return false if existing

    vehicle.company.notifications.create!(
      title: "⚠️ CRLV Vence em #{days_left} dias: #{vehicle.plate}",
      message: "O documento CRLV do veículo #{vehicle.plate} vencerá em #{I18n.l(vehicle.crlv_expiration, format: :long)}. Renove junto ao Detran.",
      notification_type: 'document_expiring',
      notifiable: vehicle
    )
    true
  end
end
