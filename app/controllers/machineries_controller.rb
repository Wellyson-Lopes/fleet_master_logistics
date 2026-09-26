# frozen_string_literal: true

class MachineriesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_machinery, only: %i[show edit update destroy]

  def index
    @machineries = policy_scope(Machinery).order(created_at: :desc)
    @machineries = @machineries.where(status: params[:status]) if params[:status].present?
    @machineries = @machineries.where(category: params[:category]) if params[:category].present?
  end

  def show
    @active_rentals = @machinery.machinery_rentals.order(start_date: :desc).limit(10)
  end

  def new
    @machinery = Machinery.new(status: 'available', hourly_rate: 150.0, daily_rate: 1200.0)
  end

  def create
    @machinery = Machinery.new(machinery_params)
    @machinery.company = current_user.company

    if @machinery.save
      redirect_to machinery_path(@machinery), notice: "Máquina #{@machinery.name} cadastrada com sucesso!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @machinery.update(machinery_params)
      redirect_to machinery_path(@machinery), notice: "Máquina #{@machinery.name} atualizada com sucesso!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @machinery.destroy
    redirect_to machineries_path, notice: 'Máquina removida com sucesso.'
  end

  private

  def set_machinery
    @machinery = policy_scope(Machinery).find(params[:id])
  end

  def machinery_params
    params.require(:machinery).permit(
      :name, :category, :brand, :model, :year,
      :serial_number, :hourly_rate, :daily_rate,
      :status, :notes
    )
  end
end
