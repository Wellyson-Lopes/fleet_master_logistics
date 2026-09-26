# frozen_string_literal: true

class DriversController < ApplicationController
  before_action :authenticate_user!
  before_action :set_driver, only: %i[show edit update destroy resend_invitation]

  def index
    @drivers = policy_scope(Driver).order(created_at: :desc)
  end

  def show; end

  def new
    @driver = Driver.new
    authorize @driver
  end

  def create
    @driver = Driver.new(driver_params)
    @driver.company = current_user.company
    @driver.cnpj = current_user.company.cnpj
    authorize @driver

    # Gera senha aleatória temporária (motorista definirá sua senha definitiva via código de convite)
    temp_pass = SecureRandom.hex(10)
    @driver.password = temp_pass
    @driver.password_confirmation = temp_pass

    if @driver.save
      @driver.generate_invitation_code!
      DriverMailer.invite_with_code(@driver).deliver_later

      redirect_to driver_path(@driver),
                  notice: "Convite enviado para #{@driver.email} com código de acesso: #{@driver.invitation_code}!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @driver.update(driver_params)
      redirect_to driver_path(@driver), notice: "Motorista #{@driver.name} atualizado com sucesso!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def resend_invitation
    authorize @driver
    @driver.generate_invitation_code!
    DriverMailer.invite_with_code(@driver).deliver_later

    redirect_to driver_path(@driver),
                notice: "Novo código de convite enviado para #{@driver.email}: #{@driver.invitation_code}!"
  end

  def destroy
    @driver.destroy
    redirect_to drivers_path, notice: 'Motorista removido com sucesso.'
  end

  private

  def set_driver
    @driver = policy_scope(Driver).find(params[:id])
  end

  def driver_params
    params.require(:driver).permit(:name, :email, :phone, :cpf, :cnh, :cnh_expiration, :active)
  end
end
