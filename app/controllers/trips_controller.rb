# frozen_string_literal: true

class TripsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_trip, only: %i[show edit update destroy update_status]

  def index
    @trips = policy_scope(Trip).includes(:vehicle, :driver).order(created_at: :desc)
    @trips = @trips.where(status: params[:status]) if params[:status].present?

    if params[:query].present?
      q = "%#{params[:query]}%"
      search_sql = 'trips.code ILIKE :q OR trips.origin ILIKE :q OR trips.destination ILIKE :q OR ' \
                   'trips.client_name ILIKE :q OR vehicles.plate ILIKE :q OR drivers.name ILIKE :q'
      @trips = @trips.joins(:vehicle, :driver).where(search_sql, q: q)
    end

    # Métricas agregadas de logística
    @total_freight_value = @trips.sum(:freight_value)
    @total_cargo_weight_ton = (@trips.sum(:cargo_weight_kg) / 1000.0).round(1)
    @in_transit_count = @trips.where(status: 'in_transit').count

    respond_to do |format|
      format.html
      format.csv do
        send_data ExportService.trips_to_excel(@trips),
                  filename: "viagens_fleetmaster_#{Date.current}.csv",
                  type: 'text/csv; charset=utf-8'
      end
    end
  end

  def show; end

  def new
    @trip = Trip.new(freight_value: 0.0, cargo_weight_kg: 0)
    load_form_resources
  end

  def create
    @trip = Trip.new(trip_params)
    @trip.company = current_user.company

    if @trip.save
      @trip.driver.driver_notifications.create(
        company_id: @trip.company_id,
        title: "Nova Viagem: #{@trip.code}",
        message: "Nova rota atribuída de #{@trip.origin} para #{@trip.destination}. Carga: #{@trip.cargo_description}.",
        notification_type: 'new_trip',
        notifiable: @trip
      )

      redirect_to trip_path(@trip), notice: "Viagem #{@trip.code} criada com sucesso para #{@trip.destination}!"
    else
      load_form_resources
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    load_form_resources
  end

  def update
    if @trip.update(trip_params)
      redirect_to trip_path(@trip), notice: "Viagem #{@trip.code} atualizada com sucesso!"
    else
      load_form_resources
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @trip.destroy
    redirect_to trips_path, notice: "Viagem #{@trip.code} cancelada e removida com sucesso."
  end

  def update_status
    new_status = params[:new_status]

    if Trip::STATUSES.include?(new_status)
      case new_status
      when 'in_transit'
        @trip.started_at ||= Time.current
      when 'delivered'
        @trip.delivered_at ||= Time.current
      end

      @trip.update(status: new_status)
      redirect_to trip_path(@trip), notice: "Status da viagem alterado para #{@trip.status_human}."
    else
      redirect_to trip_path(@trip), alert: 'Status inválido informado.'
    end
  end

  private

  def set_trip
    @trip = policy_scope(Trip).find(params[:id])
  end

  def load_form_resources
    @vehicles = current_user.company.vehicles.order(:plate)
    @drivers = current_user.company.drivers.order(:name)
    @clients = current_user.company.clients.active.order(:name)
  end

  def trip_params
    params.require(:trip).permit(
      :code, :vehicle_id, :driver_id, :client_id, :origin, :destination,
      :client_name, :cargo_description, :cargo_weight_kg,
      :freight_value, :distance_km, :status, :started_at,
      :estimated_delivery_at, :notes
    )
  end
end
