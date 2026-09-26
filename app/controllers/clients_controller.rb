# frozen_string_literal: true

class ClientsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_client, only: %i[show edit update destroy]

  def index
    @clients = policy_scope(Client).order(created_at: :desc)
    return unless params[:query].present?

    @clients = @clients.where('name ILIKE :q OR document ILIKE :q OR email ILIKE :q',
                              q: "%#{params[:query]}%")
  end

  def show; end

  def new
    @client = Client.new
  end

  def create
    @client = Client.new(client_params)
    @client.company = current_user.company

    if @client.save
      redirect_to client_path(@client), notice: "Cliente #{@client.name} cadastrado com sucesso!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @client.update(client_params)
      redirect_to client_path(@client), notice: "Cliente #{@client.name} atualizado com sucesso!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @client.destroy
    redirect_to clients_path, notice: 'Cliente removido com sucesso.'
  end

  private

  def set_client
    @client = policy_scope(Client).find(params[:id])
  end

  def client_params
    params.require(:client).permit(:name, :document, :email, :phone, :address, :city, :state, :zip_code, :status,
                                   :notes)
  end
end
