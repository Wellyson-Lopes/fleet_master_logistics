# frozen_string_literal: true

class VehiclesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_vehicle, only: %i[show edit update destroy assign_driver unassign_driver]

  def index
    @vehicles = policy_scope(Vehicle).order(created_at: :desc)
    @vehicles = @vehicles.by_type(params[:type]) if params[:type].present?
    @vehicles = @vehicles.where(status: params[:status]) if params[:status].present?

    respond_to do |format|
      format.html
      format.csv do
        send_data ExportService.vehicles_to_excel(@vehicles),
                  filename: "frota_veiculos_#{Date.current}.csv",
                  type: 'text/csv; charset=utf-8'
      end
    end
  end

  def show; end

  def new
    unless current_user.company.can_add_vehicle?
      redirect_to vehicles_path, alert: "Você atingiu o limite de caminhões do seu plano (#{current_user.company.plan_name_human}). Faça um upgrade para adicionar mais!"
      return
    end

    @vehicle = Vehicle.new
  end

  def create
    unless current_user.company.can_add_vehicle?
      redirect_to vehicles_path, alert: "Você atingiu o limite de caminhões do seu plano (#{current_user.company.plan_name_human}). Faça um upgrade para adicionar mais!"
      return
    end

    @vehicle = Vehicle.new(vehicle_params)
    @vehicle.company = current_user.company

    if @vehicle.save
      redirect_to vehicles_path, notice: "Veículo #{@vehicle.plate} cadastrado com sucesso!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @vehicle.update(vehicle_params)
      redirect_to vehicle_path(@vehicle), notice: "Veículo #{@vehicle.plate} atualizado com sucesso!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @vehicle.destroy
    redirect_to vehicles_path, notice: "Veículo #{@vehicle.plate} removido da frota."
  end

  def assign_driver
    driver = current_user.company.drivers.find(params[:driver_id])
    
    # Encerra atribuição anterior do veículo se existir
    @vehicle.current_assignment&.update(unassigned_at: Time.current)
    
    # Encerra atribuição anterior do motorista se existir
    VehicleAssignment.where(driver: driver, unassigned_at: nil).update_all(unassigned_at: Time.current)

    VehicleAssignment.create!(
      vehicle: @vehicle,
      driver: driver,
      assigned_at: Time.current
    )

    redirect_to vehicle_path(@vehicle), notice: "Motorista #{driver.name} atribuído ao veículo #{@vehicle.plate} com sucesso!"
  end

  def unassign_driver
    if assignment = @vehicle.current_assignment
      assignment.update(unassigned_at: Time.current)
      redirect_to vehicle_path(@vehicle), notice: "Motorista desatribuído do veículo #{@vehicle.plate}."
    else
      redirect_to vehicle_path(@vehicle), alert: "Este veículo não possui motorista atribuído."
    end
  end

  private

  def set_vehicle
    @vehicle = policy_scope(Vehicle).find(params[:id])
  end

  def vehicle_params
    params.require(:vehicle).permit(:type, :plate, :brand, :model, :year, :load_capacity_kg, :current_mileage_km, :status, :chassis, :renavam, :crlv_number, :crlv_expiration, :photo)
  end
end
