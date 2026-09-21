# frozen_string_literal: true

class ReportsController < ApplicationController
  before_action :authenticate_user!

  def index
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
    @total_revenue = @trips.sum(:freight_value)
    @total_cargo_kg = @trips.sum(:cargo_weight_kg)
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
      avg_occupancy = (vehicle_trips.sum(&:capacity_occupancy_percentage) / vehicle_trips.size).round(1)
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
