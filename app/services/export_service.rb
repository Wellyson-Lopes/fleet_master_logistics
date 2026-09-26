# frozen_string_literal: true

require 'csv'

# Serviço responsável por gerar planilhas compatíveis com Microsoft Excel e relatórios de dados.
# Utiliza o BOM UTF-8 (\xEF\xBB\xBF) para garantir abertura perfeita de acentos e caracteres especiais no Excel.
class ExportService
  BOM = "\xEF\xBB\xBF"

  # Gera planilha Excel/CSV de viagens e fretes
  #
  # @param trips [ActiveRecord::Relation]
  # @return [String]
  def self.trips_to_excel(trips)
    headers = [
      'Código da Viagem', 'Origem', 'Destino', 'Cliente',
      'Descrição da Carga', 'Peso (kg)', 'Valor do Frete (R$)', 'Distância (km)',
      'Placa do Veículo', 'Modelo do Caminhão', 'Motorista', 'Status',
      'Data de Saída', 'Previsão de Entrega', 'Data de Entrega'
    ]

    csv_data = CSV.generate(col_sep: ';', encoding: 'UTF-8') do |csv|
      csv << headers

      trips.each do |t|
        csv << [
          t.code,
          t.origin,
          t.destination,
          t.client_name,
          t.cargo_description,
          t.cargo_weight_kg,
          t.freight_value.to_f,
          t.distance_km,
          t.vehicle&.plate,
          "#{t.vehicle&.brand} #{t.vehicle&.model}".strip,
          t.driver&.name,
          t.status_human,
          t.started_at ? I18n.l(t.started_at, format: :short) : '-',
          t.estimated_delivery_at ? I18n.l(t.estimated_delivery_at, format: :short) : '-',
          t.delivered_at ? I18n.l(t.delivered_at, format: :short) : '-'
        ]
      end
    end

    "#{BOM}#{csv_data}"
  end

  # Gera planilha Excel/CSV de aluguel de máquinas pesadas
  #
  # @param rentals [ActiveRecord::Relation]
  # @return [String]
  def self.rentals_to_excel(rentals)
    headers = [
      'Código do Contrato', 'Equipamento / Máquina', 'Categoria', 'Cliente',
      'Documento Cliente', 'Modalidade', 'Duração', 'Taxa Aplicada (R$)',
      'Valor Total (R$)', 'Data Início', 'Data Término', 'Status'
    ]

    csv_data = CSV.generate(col_sep: ';', encoding: 'UTF-8') do |csv|
      csv << headers

      rentals.each do |r|
        csv << [
          r.code,
          r.machinery&.name,
          r.machinery&.category,
          r.client&.name,
          r.client&.formatted_document,
          r.rental_type_human,
          "#{r.duration.to_i} #{r.rental_type == 'hourly' ? 'horas' : 'dias'}",
          r.rate_applied.to_f,
          r.total_amount.to_f,
          r.start_date ? I18n.l(r.start_date, format: :short) : '-',
          r.end_date ? I18n.l(r.end_date, format: :short) : 'Em aberto',
          r.status_human
        ]
      end
    end

    "#{BOM}#{csv_data}"
  end

  # Gera planilha Excel/CSV de frotas e veículos
  #
  # @param vehicles [ActiveRecord::Relation]
  # @return [String]
  def self.vehicles_to_excel(vehicles)
    headers = [
      'Placa', 'Tipo', 'Marca', 'Modelo', 'Ano',
      'Capacidade de Carga (kg)', 'Quilometragem (km)', 'Status',
      'Motorista Alocado Atual', 'Chassi', 'Renavam'
    ]

    csv_data = CSV.generate(col_sep: ';', encoding: 'UTF-8') do |csv|
      csv << headers

      vehicles.each do |v|
        csv << [
          v.plate,
          v.type,
          v.brand,
          v.model,
          v.year,
          v.load_capacity_kg,
          v.current_mileage_km,
          v.status,
          v.current_driver&.name || 'Disponível / Sem motorista',
          v.chassis,
          v.renavam
        ]
      end
    end

    "#{BOM}#{csv_data}"
  end
end
