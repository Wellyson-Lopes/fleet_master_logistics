# frozen_string_literal: true

class MachineryRentalsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_rental, only: %i[show edit update destroy complete cancel]

  def index
    @rentals = policy_scope(MachineryRental).includes(:machinery, :client).order(created_at: :desc)
    @rentals = @rentals.where(status: params[:status]) if params[:status].present?

    # Métricas de Aluguel
    @total_rentals = @rentals.count
    @active_rentals_count = @rentals.where(status: 'active').count
    @total_revenue = @rentals.where(status: %w[active completed]).sum(:total_amount)

    respond_to do |format|
      format.html
      format.csv do
        send_data ExportService.rentals_to_excel(@rentals),
                  filename: "aluguel_maquinas_#{Date.current}.csv",
                  type: 'text/csv; charset=utf-8'
      end
    end
  end

  def show; end

  def new
    @rental = MachineryRental.new(
      rental_type: 'daily',
      duration: 1,
      start_date: Time.current,
      status: 'active'
    )
    load_form_resources
    authorize @rental
  end

  def create
    @rental = MachineryRental.new(rental_params)
    @rental.company = current_user.company
    authorize @rental

    if @rental.save
      redirect_to machinery_rental_path(@rental),
                  notice: "Contrato de aluguel #{@rental.code} registrado com sucesso para #{@rental.client.name}!"
    else
      load_form_resources
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    load_form_resources
  end

  def update
    if @rental.update(rental_params)
      redirect_to machinery_rental_path(@rental), notice: "Contrato de aluguel #{@rental.code} atualizado com sucesso!"
    else
      load_form_resources
      render :edit, status: :unprocessable_entity
    end
  end

  def complete
    @rental.update(status: 'completed', end_date: Time.current)
    redirect_to machinery_rental_path(@rental), notice: "Locação #{@rental.code} finalizada! Máquina liberada."
  end

  def cancel
    @rental.update(status: 'canceled', end_date: Time.current)
    redirect_to machinery_rental_path(@rental), notice: "Locação #{@rental.code} cancelada."
  end

  def destroy
    @rental.destroy
    redirect_to machinery_rentals_path, notice: 'Registro de locação removido com sucesso.'
  end

  private

  def set_rental
    @rental = policy_scope(MachineryRental).find(params[:id])
  end

  def load_form_resources
    @machineries = policy_scope(Machinery).order(:name)
    @clients = policy_scope(Client).active.order(:name)
  end

  def rental_params
    params.require(:machinery_rental).permit(
      :machinery_id, :client_id, :rental_type, :duration,
      :rate_applied, :start_date, :end_date, :delivery_address,
      :notes, :status
    )
  end
end
