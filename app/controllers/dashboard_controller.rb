# frozen_string_literal: true

class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    @company = current_user.company
    @vehicles = policy_scope(Vehicle)
    @drivers = policy_scope(Driver)

    # Métricas da frota real da empresa
    @total_vehicles = @vehicles.count
    @available_vehicles = @vehicles.where(status: 'active').count
    @maintenance_vehicles = @vehicles.where(status: 'maintenance').count
    @inactive_vehicles = @vehicles.where(status: 'inactive').count

    # Métricas de motoristas
    @total_drivers = @drivers.count
    @active_drivers = @drivers.where(active: true).count

    # Veículos em rota (entregas ativas em andamento)
    @in_transit_trips = policy_scope(Trip).where(status: %w[in_transit delayed])
                                          .includes(:vehicle, :driver)
                                          .order(started_at: :desc)

    # Veículos com motoristas atribuídos em operação
    @active_assignments = VehicleAssignment.joins(:vehicle)
                                           .where(vehicles: { company_id: @company.id }, unassigned_at: nil)
                                           .includes(:vehicle, :driver)
                                           .order(assigned_at: :desc)
                                           .limit(5)

    # Alertas reais de CNH da empresa
    @cnh_alerts = @drivers.where.not(cnh_expiration: nil)
                          .where('cnh_expiration <= ?', 45.days.from_now)
                          .order(cnh_expiration: :asc)
                          .limit(5)

    # Alertas reais de CRLV de veículos da empresa
    @crlv_alerts = @vehicles.where.not(crlv_expiration: nil)
                            .where('crlv_expiration <= ?', 45.days.from_now)
                            .order(crlv_expiration: :asc)
                            .limit(5)

    # Máquinas e Locações ativas
    @active_rentals = policy_scope(MachineryRental).where(status: 'active').includes(:machinery, :client).limit(5)

    # Veículos cadastrados recentemente
    @recent_vehicles = @vehicles.order(created_at: :desc).limit(5)
  end
end
