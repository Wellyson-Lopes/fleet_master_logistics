# frozen_string_literal: true

puts '== Populando dados reais e variados para o FleetMaster Logistics =='

# 1. Criação ou recuperação da empresa principal
company_cnpj = '12.345.678/0001-95'
company_cnpj = CNPJ.generate(true) unless CNPJ.valid?(company_cnpj)

company = Company.find_or_initialize_by(name: 'TransLogística Brasil S.A.')
company.cnpj = company_cnpj if company.new_record? || !CNPJ.valid?(company.cnpj)
company.plan = 'pro'
company.billing_cycle = 'monthly'
company.subscription_status = 'active'
company.trial_ends_at = 30.days.from_now
company.save!
puts "✓ Empresa: #{company.name} (CNPJ: #{company.cnpj}, Plano: #{company.plan_name_human})"

# 2. Usuário Administrador (Gestor da Frota)
admin_user = User.find_or_initialize_by(email: 'admin@fleetmaster.com')
admin_user.name = 'Wellyson Gestor Logístico'
admin_user.password = 'password123'
admin_user.password_confirmation = 'password123'
admin_user.company = company
admin_user.company_name = company.name
admin_user.cnpj = company.cnpj
admin_user.admin = true
admin_user.save!
puts "✓ Administrador: #{admin_user.email} (Senha: password123)"

# 3. Clientes (Distribuidoras, Construtoras, Mercearias e Agro)
clients_data = [
  {
    name: 'Construtora Horizonte S.A.',
    document: CNPJ.generate(true),
    email: 'contato@horizonte.com.br',
    phone: '(11) 3456-7890',
    address: 'Av. das Nações Unidas, 14200',
    city: 'São Paulo',
    state: 'SP',
    zip_code: '04794-000',
    status: 'active',
    notes: 'Obras pesadas e fundações. Exige caminhão traçado e motorista com NR-18.'
  },
  {
    name: 'Distribuidora de Alimentos Boa Safra',
    document: CNPJ.generate(true),
    email: 'compras@boasafra.com.br',
    phone: '(19) 3210-9876',
    address: 'Rod. Anhanguera, km 104',
    city: 'Campinas',
    state: 'SP',
    zip_code: '13069-901',
    status: 'active',
    notes: 'Recebimento de cargas paletizadas das 06h às 14h.'
  },
  {
    name: 'Mineração Vale do Sul Ltda',
    document: CNPJ.generate(true),
    email: 'operacoes@valedosul.ind.br',
    phone: '(31) 3322-1100',
    address: 'Distrito Industrial s/n',
    city: 'Belo Horizonte',
    state: 'MG',
    zip_code: '30100-000',
    status: 'active',
    notes: 'Locação de pás carregadeiras e caminhões basculantes pesados.'
  },
  {
    name: 'Rede Atacadista Progresso',
    document: CNPJ.generate(true),
    email: 'logistica@atacadoprogresso.com.br',
    phone: '(41) 3344-5566',
    address: 'Rua Marechal Deodoro, 800',
    city: 'Curitiba',
    state: 'PR',
    zip_code: '80010-010',
    status: 'active',
    notes: 'Cliente de entregas recorrentes no Paraná e Santa Catarina.'
  }
]

clients = {}
clients_data.each do |cdata|
  client = Client.find_or_initialize_by(name: cdata[:name], company: company)
  client.assign_attributes(cdata)
  client.save!
  clients[client.name] = client
  puts "✓ Cliente: #{client.name} (#{client.city}/#{client.state})"
end

# 4. Motoristas da Frota
drivers_data = [
  {
    name: 'Carlos Eduardo Silva',
    email: 'carlos.silva@translog.com.br',
    cpf: CPF.generate(true),
    cnh: '12345678900',
    cnh_expiration: 1.year.from_now.to_date,
    phone: '(11) 98765-4321',
    active: true,
    current_latitude: -23.550520,
    current_longitude: -46.633308,
    last_location_at: 10.minutes.ago
  },
  {
    name: 'Marcos Roberto Rocha',
    email: 'marcos.rocha@translog.com.br',
    cpf: CPF.generate(true),
    cnh: '23456789011',
    cnh_expiration: 15.days.from_now.to_date, # Alerta CNH prestes a vencer
    phone: '(11) 97654-3210',
    active: true,
    current_latitude: -25.428954,
    current_longitude: -49.267137,
    last_location_at: 5.minutes.ago
  },
  {
    name: 'Ana Paula Ferreira',
    email: 'ana.ferreira@translog.com.br',
    cpf: CPF.generate(true),
    cnh: '34567890122',
    cnh_expiration: 2.years.from_now.to_date,
    phone: '(11) 96543-2109',
    active: true,
    current_latitude: -19.916681,
    current_longitude: -43.934493,
    last_location_at: 2.minutes.ago
  },
  {
    name: 'José Vicente Santos',
    email: 'jose.santos@translog.com.br',
    cpf: CPF.generate(true),
    cnh: '45678901233',
    cnh_expiration: 5.days.ago.to_date, # CNH vencida (alerta crítico)
    phone: '(11) 95432-1098',
    active: true,
    current_latitude: -22.906847,
    current_longitude: -43.172896,
    last_location_at: 1.hour.ago
  }
]

drivers = {}
drivers_data.each do |data|
  driver = Driver.find_or_initialize_by(email: data[:email])
  driver.name = data[:name]
  driver.password = 'password123'
  driver.password_confirmation = 'password123'
  driver.company = company
  driver.cnpj = company.cnpj
  driver.cpf = data[:cpf] if driver.new_record? || driver.cpf.blank?
  driver.cnh = data[:cnh]
  driver.cnh_expiration = data[:cnh_expiration]
  driver.phone = data[:phone]
  driver.active = data[:active]
  driver.current_latitude = data[:current_latitude]
  driver.current_longitude = data[:current_longitude]
  driver.last_location_at = data[:last_location_at]
  driver.save!
  drivers[data[:email]] = driver
  puts "✓ Motorista: #{driver.name} (#{driver.email})"
end

# 5. Veículos da Frota com Documentação CRLV
vehicles_data = [
  {
    plate: 'BRA-2E19',
    type: 'Caminhão Pesado / Truck',
    brand: 'Volvo',
    model: 'FH 540 Globetrotter 6x4',
    year: 2023,
    load_capacity_kg: 24_000,
    current_mileage_km: 54_200,
    status: 'active',
    chassis: '9BWCA1110FP002341',
    renavam: '01234567890',
    crlv_number: 'CRLV-2026-9812',
    crlv_expiration: 6.months.from_now.to_date,
    driver_email: 'carlos.silva@translog.com.br'
  },
  {
    plate: 'RJZ-4B82',
    type: 'Carreta Graneleira',
    brand: 'Scania',
    model: 'R 450 Highline 6x2',
    year: 2022,
    load_capacity_kg: 32_000,
    current_mileage_km: 91_400,
    status: 'active',
    chassis: '9BWCA1110FP004562',
    renavam: '09876543211',
    crlv_number: 'CRLV-2026-4431',
    crlv_expiration: 12.days.from_now.to_date, # CRLV vencendo em breve
    driver_email: 'ana.ferreira@translog.com.br'
  },
  {
    plate: 'MGA-7C34',
    type: 'Caminhão Basculante',
    brand: 'Mercedes-Benz',
    model: 'Actros 2651',
    year: 2021,
    load_capacity_kg: 23_000,
    current_mileage_km: 128_900,
    status: 'maintenance',
    chassis: '9BWCA1110FP008711',
    renavam: '03456789123',
    crlv_number: 'CRLV-2026-1189',
    crlv_expiration: 2.days.ago.to_date, # CRLV vencido
    driver_email: nil
  },
  {
    plate: 'SPK-9D50',
    type: 'VUC / Baú Urbano',
    brand: 'Volkswagen',
    model: 'Delivery 11.180',
    year: 2024,
    load_capacity_kg: 7500,
    current_mileage_km: 14_800,
    status: 'active',
    chassis: '9BWCA1110FP009944',
    renavam: '05678912345',
    crlv_number: 'CRLV-2026-7721',
    crlv_expiration: 1.year.from_now.to_date,
    driver_email: 'marcos.rocha@translog.com.br'
  }
]

vehicles = {}
vehicles_data.each do |vdata|
  driver_email = vdata.delete(:driver_email)
  vehicle = Vehicle.find_or_initialize_by(plate: vdata[:plate], company: company)
  vehicle.assign_attributes(vdata)
  vehicle.save!
  vehicles[vehicle.plate] = vehicle
  puts "✓ Veículo: #{vehicle.plate} - #{vehicle.brand} #{vehicle.model} (#{vehicle.status})"

  next unless driver_email && (driver = drivers[driver_email])

  assignment = VehicleAssignment.find_or_initialize_by(vehicle: vehicle, driver: driver, unassigned_at: nil)
  assignment.assigned_at = 2.weeks.ago if assignment.new_record?
  assignment.save!
  puts "  ↳ Alocado para motorista: #{driver.name}"
end

# 6. Máquinas Pesadas para Locação
machineries_data = [
  {
    name: 'Escavadeira Hidráulica Caterpillar 320D',
    category: 'escavadeira',
    brand: 'Caterpillar',
    model: '320D3',
    year: 2023,
    serial_number: 'CAT0320DPX99281',
    hourly_rate: 220.00,
    daily_rate: 1650.00,
    status: 'rented',
    notes: 'Equipada com caçamba de 1.2m³ reforçada para rocha.'
  },
  {
    name: 'Retroescavadeira JCB 3CX 4x4',
    category: 'retroescavadeira',
    brand: 'JCB',
    model: '3CX',
    year: 2022,
    serial_number: 'JCB3CX00281928',
    hourly_rate: 150.00,
    daily_rate: 1100.00,
    status: 'available',
    notes: 'Cabine fechada com ar condicionado, tração integral.'
  },
  {
    name: 'Pá Carregadeira Case 721E',
    category: 'pa_carregadeira',
    brand: 'Case',
    model: '721E',
    year: 2021,
    serial_number: 'CASE72109921',
    hourly_rate: 190.00,
    daily_rate: 1400.00,
    status: 'available',
    notes: 'Ideal para carregamento de brita, areia e terra.'
  },
  {
    name: 'Motoniveladora Caterpillar 140K',
    category: 'motoniveladora',
    brand: 'Caterpillar',
    model: '140K',
    year: 2020,
    serial_number: 'CAT140K77123',
    hourly_rate: 250.00,
    daily_rate: 1850.00,
    status: 'maintenance',
    notes: 'Troca programada de facas e revisão do circuito hidráulico.'
  }
]

machineries = {}
machineries_data.each do |mdata|
  machinery = Machinery.find_or_initialize_by(serial_number: mdata[:serial_number], company: company)
  machinery.assign_attributes(mdata)
  machinery.save!
  machineries[machinery.name] = machinery
  puts "✓ Máquina: #{machinery.name} (#{machinery.category}, R$ #{machinery.daily_rate}/dia)"
end

# 7. Contratos de Locação de Máquinas
rentals_data = [
  {
    code: 'LOC-2026-01',
    machinery_name: 'Escavadeira Hidráulica Caterpillar 320D',
    client_name: 'Mineração Vale do Sul Ltda',
    rental_type: 'daily',
    duration: 15,
    rate_applied: 1650.00,
    total_amount: 24_750.00,
    start_date: 5.days.ago,
    end_date: 10.days.from_now,
    status: 'active',
    delivery_address: 'Mina da Esperança, Trecho 4, Belo Horizonte - MG',
    notes: 'Locação com plano de manutenção preventiva incluso no local.'
  },
  {
    code: 'LOC-2026-02',
    machinery_name: 'Retroescavadeira JCB 3CX 4x4',
    client_name: 'Construtora Horizonte S.A.',
    rental_type: 'hourly',
    duration: 40,
    rate_applied: 150.00,
    total_amount: 6000.00,
    start_date: 20.days.ago,
    end_date: 15.days.ago,
    status: 'completed',
    delivery_address: 'Canteiro de Obras Lapa, São Paulo - SP',
    notes: 'Devolvida limpa e revisada sem pendências.'
  }
]

rentals_data.each do |rdata|
  machinery = machineries[rdata.delete(:machinery_name)]
  client = clients[rdata.delete(:client_name)]
  next unless machinery && client

  rental = MachineryRental.find_or_initialize_by(code: rdata[:code], company: company)
  rental.assign_attributes(rdata)
  rental.machinery = machinery
  rental.client = client
  rental.save!
  puts "✓ Locação: #{rental.code} - #{machinery.name} para #{client.name} (R$ #{rental.total_amount})"
end

# 8. Viagens da Operação (Vários Status: scheduled, accepted, in_transit, delivered, delayed, not_delivered)
trips_data = [
  {
    code: 'TRP-8412',
    plate: 'BRA-2E19',
    driver_email: 'carlos.silva@translog.com.br',
    client_name: 'Construtora Horizonte S.A.',
    origin: 'São Paulo - SP (CD Lapa)',
    destination: 'Curitiba - PR (Parque Industrial)',
    cargo_description: '20 Paletes de Cimento e Vergalhões de Aço',
    cargo_weight_kg: 21_500,
    freight_value: 6800.00,
    distance_km: 410,
    status: 'in_transit',
    started_at: 4.hours.ago,
    estimated_delivery_at: 3.hours.from_now,
    notes: 'Caminhão na BR-116 sentido Sul. Sinal de GPS enviando a cada 5 min.'
  },
  {
    code: 'TRP-8413',
    plate: 'RJZ-4B82',
    driver_email: 'ana.ferreira@translog.com.br',
    client_name: 'Distribuidora de Alimentos Boa Safra',
    origin: 'Porto de Santos - SP',
    destination: 'Campinas - SP',
    cargo_description: 'Container com 28t de Cacau e Açúcar Especial',
    cargo_weight_kg: 28_000,
    freight_value: 8200.00,
    distance_km: 180,
    status: 'in_transit',
    started_at: 2.hours.ago,
    estimated_delivery_at: 2.hours.from_now,
    notes: 'Escolta e rastreamento via satélite ativado.'
  },
  {
    code: 'TRP-8410',
    plate: 'SPK-9D50',
    driver_email: 'marcos.rocha@translog.com.br',
    client_name: 'Rede Atacadista Progresso',
    origin: 'Campinas - SP',
    destination: 'Ribeirão Preto - SP',
    cargo_description: 'Bebidas e Alimentos Industrializados',
    cargo_weight_kg: 6800,
    freight_value: 3200.00,
    distance_km: 220,
    status: 'delivered',
    started_at: 2.days.ago,
    delivered_at: 1.day.ago,
    estimated_delivery_at: 1.day.ago,
    notes: 'Entrega realizada com sucesso. Comprovante assinado no portal.'
  },
  {
    code: 'TRP-8415',
    plate: 'BRA-2E19',
    driver_email: 'carlos.silva@translog.com.br',
    client_name: 'Mineração Vale do Sul Ltda',
    origin: 'São Paulo - SP',
    destination: 'Belo Horizonte - MG',
    cargo_description: 'Peças de Reposição Pesadas e Correias',
    cargo_weight_kg: 18_500,
    freight_value: 7500.00,
    distance_km: 580,
    status: 'scheduled',
    estimated_delivery_at: 2.days.from_now,
    notes: 'Aguardando carregamento no galpão central.'
  },
  {
    code: 'TRP-8418',
    plate: 'RJZ-4B82',
    driver_email: 'ana.ferreira@translog.com.br',
    client_name: 'Rede Atacadista Progresso',
    origin: 'Curitiba - PR',
    destination: 'Joinville - SC',
    cargo_description: 'Alimentos Congelados',
    cargo_weight_kg: 15_000,
    freight_value: 4100.00,
    distance_km: 130,
    status: 'not_delivered',
    status_reason: 'quebra',
    started_at: 1.day.ago,
    notes: 'Motorista reportou pane elétrica na Serra do Mar.'
  }
]

trips_data.each do |tdata|
  vehicle = vehicles[tdata.delete(:plate)]
  driver = drivers[tdata.delete(:driver_email)]
  client = clients[tdata[:client_name]]

  trip = Trip.find_or_initialize_by(code: tdata[:code], company: company)
  trip.assign_attributes(tdata)
  trip.vehicle = vehicle
  trip.driver = driver
  trip.client = client
  trip.save!
  puts "✓ Viagem: #{trip.code} (#{trip.origin} → #{trip.destination}) [#{trip.status_human}]"

  # Se for em trânsito, adiciona histórico de localização GPS
  if trip.status == 'in_transit'
    DriverLocation.create!(
      company: company,
      driver: driver,
      trip: trip,
      latitude: driver.current_latitude,
      longitude: driver.current_longitude,
      speed: 78.5,
      heading: 180.0,
      recorded_at: 5.minutes.ago
    )
  end

  # Se for not_delivered ou incidente, adiciona ocorrência
  next unless trip.status == 'not_delivered'

  TripStatusUpdate.find_or_create_by!(
    company: company,
    trip: trip,
    driver: driver,
    status: 'not_delivered',
    reason: trip.status_reason || 'quebra',
    notes: 'Falha mecânica com superaquecimento. Guincho solicitado.'
  )
end

# 9. Abastecimentos da Frota
fuel_data = [
  {
    vehicle_plate: 'BRA-2E19',
    driver_email: 'carlos.silva@translog.com.br',
    current_mileage_km: 54_200,
    liters: 280.0,
    total_amount: 1680.00,
    fuel_type: 'diesel_s10',
    notes: 'Posto Graal Rodovia Régis Bittencourt km 298.'
  },
  {
    vehicle_plate: 'RJZ-4B82',
    driver_email: 'ana.ferreira@translog.com.br',
    current_mileage_km: 91_400,
    liters: 320.0,
    total_amount: 1920.00,
    fuel_type: 'diesel_s10',
    notes: 'Posto Petrobras Santos Porto.'
  },
  {
    vehicle_plate: 'SPK-9D50',
    driver_email: 'marcos.rocha@translog.com.br',
    current_mileage_km: 14_800,
    liters: 95.0,
    total_amount: 570.00,
    fuel_type: 'diesel_s10',
    notes: 'Posto Ipiranga Rod. Bandeirantes.'
  }
]

fuel_data.each do |fdata|
  v = vehicles[fdata.delete(:vehicle_plate)]
  d = drivers[fdata.delete(:driver_email)]
  next unless v && d

  refuel = FuelRefuel.find_or_initialize_by(
    vehicle: v,
    driver: d,
    current_mileage_km: fdata[:current_mileage_km]
  )
  refuel.company = company
  refuel.assign_attributes(fdata)
  refuel.save!
  puts "✓ Abastecimento: #{v.plate} - #{refuel.liters}L #{refuel.fuel_type_human} (R$ #{refuel.total_amount})"
end

# 10. Notificações Internas (Painel Web e App Mobile)
notifications_data = [
  {
    title: '⚠️ Incidente Reportado: TRP-8418',
    message: 'A motorista Ana Paula reportou quebra mecânica no trajeto Curitiba → Joinville.',
    notification_type: 'incident',
    read: false
  },
  {
    title: '⛽ Novo Abastecimento Registrado',
    message: 'O motorista Carlos Eduardo registrou abastecimento de 280L de Diesel S-10 no veículo BRA-2E19.',
    notification_type: 'fuel_refuel',
    read: false
  },
  {
    title: '🚨 Alerta de Vencimento de Documentos',
    message: 'A CNH do motorista Marcos Roberto vence em 15 dias. O CRLV do veículo RJZ-4B82 vence em 12 dias.',
    notification_type: 'document_expiring',
    read: false
  },
  {
    title: '🚜 Novo Contrato de Locação',
    message: 'Contrato LOC-2026-01 iniciado para Mineração Vale do Sul (Escavadeira CAT 320D).',
    notification_type: 'system',
    read: true,
    read_at: 1.day.ago
  }
]

notifications_data.each do |ndata|
  n = Notification.find_or_initialize_by(title: ndata[:title], company: company)
  n.assign_attributes(ndata)
  n.save!
  puts "✓ Notificação Web: #{n.title}"
end

# Notificações no App Mobile dos Motoristas
drivers.each_value do |driver|
  DriverNotification.find_or_create_by!(
    driver: driver,
    company: company,
    title: 'Bem-vindo ao FleetMaster Driver!',
    message: 'Seu aplicativo está ativo. Acompanhe suas rotas, confirme entregas e ' \
             'registre abastecimentos em tempo real.',
    notification_type: 'welcome',
    read: false
  )
end

puts "\n========================================================"
puts '🎉 BASE DE DADOS COMPLETA POPULADA COM SUCESSO!'
puts '========================================================'
puts "• 1 Empresa Multi-Tenant: #{company.name}"
puts '• 1 Usuário Web Gestor: admin@fleetmaster.com / password123'
puts '• 4 Clientes: Construtoras, Distribuidoras, Mineração e Atacado'
puts '• 4 Motoristas com GPS: Carlos, Marcos, Ana Paula, José Vicente'
puts '• 4 Veículos: Trucks, Carretas, VUCs, Basculante com CRLVs'
puts '• 4 Máquinas Pesadas: Escavadeiras, Retroescavadeiras, Pás e Motoniveladoras'
puts '• 2 Contratos de Locação (Ativo e Concluído)'
puts '• 5 Viagens em diferentes estados (Em Trânsito, Entregue, Agendada, Ocorrência)'
puts '• 3 Abastecimentos com odômetro e custos de combustível'
puts '• Central de Notificações Web e Pushs do Motorista configurados'
puts '========================================================'
