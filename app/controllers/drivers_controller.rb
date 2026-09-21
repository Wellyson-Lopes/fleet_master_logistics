# frozen_string_literal: true

class DriversController < ApplicationController
  before_action :authenticate_user!
  before_action :set_driver, only: %i[show edit update destroy]

  def index
    @drivers = policy_scope(Driver).order(created_at: :desc)
  end

  def show; end

  def edit; end

  def update
    if @driver.update(driver_params)
      redirect_to driver_path(@driver), notice: "Motorista #{@driver.name} atualizado com sucesso!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @driver.destroy
    redirect_to drivers_path, notice: "Motorista removido com sucesso."
  end

  private

  def set_driver
    @driver = policy_scope(Driver).find(params[:id])
  end

  def driver_params
    params.require(:driver).permit(:name, :phone, :cpf, :cnh, :cnh_expiration, :active)
  end
end
