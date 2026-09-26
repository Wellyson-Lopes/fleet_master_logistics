# frozen_string_literal: true

class ReportsController < ApplicationController
  before_action :authenticate_user!

  def index
    load_report_data

    respond_to do |format|
      format.html
      format.csv do
        company_slug = @company&.name&.parameterize.presence || 'empresa'
        send_data ExportService.trips_to_excel(@trips),
                  filename: "relatorio_viagens_#{company_slug}_#{Date.current}.csv",
                  type: 'text/csv; charset=utf-8'
      end
      format.pdf do
        render 'print_pdf', layout: 'print'
      end
    end
  end

  # View especial otimizada para impressão direta em PDF (Ctrl+P ou salvar como PDF)
  def print_pdf
    load_report_data
    render 'print_pdf', layout: 'print'
  end

  private

  def load_report_data
    @company = current_user.company
    @trips = policy_scope(Trip).includes(:vehicle, :driver)

    # Filtragem por período
    case params[:period]
    when 'this_month'
      @trips = @trips.where('trips.created_at >= ?', Time.current.beginning_of_month)
    when 'last_30_days'
      @trips = @trips.where('trips.created_at >= ?', 30.days.ago)
    end

    # Totais consolidados
    @total_trips = @trips.count
    @total_revenue = @trips.sum(:freight_value) || 0.0
    @total_cargo_kg = @trips.sum(:cargo_weight_kg) || 0
    @total_cargo_ton = (@total_cargo_kg / 1000.0).round(1)
    @avg_ticket = @total_trips.positive? ? (@total_revenue / @total_trips).round(2) : 0.0

    # Desempenho por motorista
    @driver_stats = @trips.group_by(&:driver).map do |driver, driver_trips|
      revenue = driver_trips.sum(&:freight_value)
      cargo_ton = (driver_trips.sum(&:cargo_weight_kg) / 1000.0).round(1)
      delivered = driver_trips.count { |t| t.status == 'delivered' }
      {
        driver: driver,
        trips_count: driver_trips.count,
        delivered_count: delivered,
        revenue: revenue,
        cargo_ton: cargo_ton
      }
    end.sort_by { |s| -s[:revenue] }

    # Desempenho por veículo
    @vehicle_stats = @trips.group_by(&:vehicle).map do |vehicle, vehicle_trips|
      revenue = vehicle_trips.sum(&:freight_value)
      cargo_ton = (vehicle_trips.sum(&:cargo_weight_kg) / 1000.0).round(1)
      total_occ = vehicle_trips.sum(&:capacity_occupancy_percentage)
      avg_occupancy = vehicle_trips.any? ? (total_occ / vehicle_trips.size).round(1) : 0.0
      {
        vehicle: vehicle,
        trips_count: vehicle_trips.count,
        revenue: revenue,
        cargo_ton: cargo_ton,
        avg_occupancy: avg_occupancy
      }
    end.sort_by { |s| -s[:revenue] }
  end
end
