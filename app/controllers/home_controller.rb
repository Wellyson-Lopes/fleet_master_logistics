# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    @kpis = {
      active_vehicles: { value: '148', label: 'Veículos Ativos', delta: '+12%', trend: :up },
      trips_in_progress: { value: '32', label: 'Viagens em Curso', delta: '+8%', trend: :up },
      pending_incidents: { value: '3', label: 'Incidentes Pendentes', delta: '-2', trend: :down },
      fleet_efficiency: { value: '94.2%', label: 'Eficiência da Frota', delta: '+1.5%', trend: :up }
    }

    @vehicles = [
      { plate: 'ABC-1234', model: 'Volvo FH 540', driver: 'Carlos Souza', status: 'Em Rota', status_color: 'blue',
        fuel: 75 },
      { plate: 'XYZ-5678', model: 'Scania R 450', driver: 'Ana Paula', status: 'Disponível', status_color: 'green',
        fuel: 92 },
      { plate: 'MNO-9012', model: 'Mercedes-Benz Actros', driver: 'José Lima', status: 'Manutenção',
        status_color: 'amber', fuel: 40 },
      { plate: 'QWE-3456', model: 'Volvo FH 460', driver: 'Marcos Rocha', status: 'Em Rota', status_color: 'blue',
        fuel: 85 }
    ]

    @incidents = [
      { id: 'INC-089', type: 'Pneu Furado', vehicle: 'ABC-1234', severity: 'Baixa', status: 'Em Atendimento',
        color: 'amber' },
      { id: 'INC-088', type: 'Falha Mecânica', vehicle: 'MNO-9012', severity: 'Alta', status: 'Aguardando Guincho',
        color: 'red' },
      { id: 'INC-087', type: 'Atraso na Entrega', vehicle: 'QWE-3456', severity: 'Média', status: 'Resolvido',
        color: 'green' }
    ]

    @recent_trips = [
      { id: 'TRP-2041', destination: 'São Paulo - SP', driver: 'Carlos Souza', progress: 85, status: 'A caminho',
        color: 'blue' },
      { id: 'TRP-2042', destination: 'Rio de Janeiro - RJ', driver: 'Marcos Rocha', progress: 40, status: 'A caminho',
        color: 'blue' },
      { id: 'TRP-2043', destination: 'Belo Horizonte - MG', driver: 'Ana Paula', progress: 100, status: 'Entregue',
        color: 'green' }
    ]
  end
end
