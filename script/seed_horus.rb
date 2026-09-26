# frozen_string_literal: true

require_relative '../config/environment'

puts "=== Populando dados completos para a empresa HORUS ==="

horus = Company.find_by("name ILIKE ?", "%horus%")
unless horus
  puts "Empresa Horus não encontrada!"
  exit 1
end

horus.update!(
  plan: 'pro',
  billing_cycle: 'monthly',
  subscription_status: 'active',
  trial_ends_at: 30.days.from_now
)
puts "✓ Empresa: #{horus.name} (CNPJ: #{horus.cnpj}, Plano: #{horus.plan_name_human})"

# 1. Clientes
clients_data = [
  {
    name: "Supermercados Estrela D'Alva",
    document: CNPJ.generate(true),
    email: "compras@estreladalva.com.br",
    phone: "(11) 3221-4455",
    address: "Av. do Estado, 5000",
    city: "São Paulo",
    state: "SP",
    zip_code: "03105-000",
    status: "active",
    notes: "Recebimento de carretas das 07h às 15h. Agendamento obrigatório."
  },
  {
    name: "Distribuidora Horus Log Express",
    document: CNPJ.generate(true),
    email: "operacoes@horusexpress.com.br",
    phone: "(19) 3871-9900",
    address: "Rod. Santos Dumont, km 68",
    city: "Campinas",
    state: "SP",
    zip_code: "13055-900",
    status: "active",
    notes: "Cross-docking regional e distribuição fracionada."
  },
  {
    name: "Construtora Terra & Aço S.A.",
    document: CNPJ.generate(true),
    email: "suprimentos@terraeaco.com.br",
    phone: "(21) 2555-1234",
    address: "Av. Brasil, 18500",
    city: "Rio de Janeiro",
    state: "RJ",
    zip_code: "21515-000",
    status: "active",
    notes: "Locatário contínuo de escavadeiras pesadas e caminhões traçados."
  },
  {
    name: "Agroindústria Alvorada Ltda",
    document: CNPJ.generate(true),
    email: "contato@agroalvorada.com.br",
    phone: "(41) 3622-7788",
    address: "Estrada da Graciosa s/n",
    city: "Curitiba",
    state: "PR",
    zip_code: "80000-000",
    status: "active",
    notes: "Transporte de fertilizantes, adubos e insumos agrícolas."
  }
]

clients = {}
clients_data.each do |cdata|
  client = Client.find_or_initialize_by(name: cdata[:name], company: horus)
  client.assign_attributes(cdata)
  client.save!
  clients[client.name] = client
  puts "✓ Cliente: #{client.name} (#{client.city}/#{client.state})"
end

# 2. Motoristas
drivers_data = [
  {
    name: "Roberto Mendes",
    email: "roberto.mendes@horuslog.com.br",
    cpf: CPF.generate(true),
    cnh: "55667788990",
    cnh_expiration: 1.year.from_now.to_date,
    phone: "(11) 98111-2233",
    active: true,
    current_latitude: -23.550520,
    current_longitude: -46.633308,
    last_location_at: 5.minutes.ago
  },
  {
    name: "Juliana Costa",
    email: "juliana.costa@horuslog.com.br",
    cpf: CPF.generate(true),
    cnh: "66778899001",
    cnh_expiration: 2.years.from_now.to_date,
    phone: "(19) 98222-3344",
    active: true,
    current_latitude: -22.906847,
    current_longitude: -47.061642,
    last_location_at: 2.minutes.ago
  },
  {
    name: "Fernando Alves",
    email: "fernando.alves@horuslog.com.br",
    cpf: CPF.generate(true),
    cnh: "77889900112",
    cnh_expiration: 10.days.from_now.to_date, # Alerta de expiração próxima
    phone: "(21) 98333-4455",
    active: true,
    current_latitude: -22.906847,
    current_longitude: -43.172896,
    last_location_at: 15.minutes.ago
  },
  {
    name: "Thiago Ribeiro",
    email: "thiago.ribeiro@horuslog.com.br",
    cpf: CPF.generate(true),
    cnh: "88990011223",
    cnh_expiration: 3.days.ago.to_date, # CNH vencida (alerta crítico)
    phone: "(41) 98444-5566",
    active: true,
    current_latitude: -25.428954,
    current_longitude: -49.267137,
    last_location_at: 1.hour.ago
  }
]

drivers = {}
drivers_data.each do |ddata|
  driver = Driver.find_or_initialize_by(email: ddata[:email])
  driver.name = ddata[:name]
  driver.password = "password123"
  driver.password_confirmation = "password123"
  driver.company = horus
  driver.cnpj = horus.cnpj
  driver.cpf = ddata[:cpf] if driver.new_record? || driver.cpf.blank?
  driver.cnh = ddata[:cnh]
  driver.cnh_expiration = ddata[:cnh_expiration]
  driver.phone = ddata[:phone]
  driver.active = ddata[:active]
  driver.current_latitude = ddata[:current_latitude]
  driver.current_longitude = ddata[:current_longitude]
  driver.last_location_at = ddata[:last_location_at]
  driver.save!
  drivers[ddata[:email]] = driver
  puts "✓ Motorista: #{driver.name} (#{driver.email})"
end

# 3. Veículos da Frota
vehicles_data = [
  {
    plate: "HRS-1001",
    type: "Caminhão Pesado / Cavalo Mecânico",
    brand: "Scania",
    model: "R 500 V8 Highline",
    year: 2023,
    load_capacity_kg: 33000,
    current_mileage_km: 62400,
    status: "active",
    chassis: "9BWCA1110FP007801",
    renavam: "01928374651",
    crlv_number: "CRLV-HRS-01",
    crlv_expiration: 7.months.from_now.to_date,
    driver_email: "roberto.mendes@horuslog.com.br"
  },
  {
    plate: "HRS-2002",
    type: "Caminhão Truck 6x2",
    brand: "Volvo",
    model: "FH 460 Globetrotter",
    year: 2022,
    load_capacity_kg: 24000,
    current_mileage_km: 88200,
    status: "active",
    chassis: "9BWCA1110FP007802",
    renavam: "01928374652",
    crlv_number: "CRLV-HRS-02",
    crlv_expiration: 8.days.from_now.to_date, # CRLV vencendo em 8 dias
    driver_email: "juliana.costa@horuslog.com.br"
  },
  {
    plate: "HRS-3003",
    type: "Caminhão Toco Baú",
    brand: "Mercedes-Benz",
    model: "Atego 2426",
    year: 2021,
    load_capacity_kg: 16000,
    current_mileage_km: 114000,
    status: "active",
    chassis: "9BWCA1110FP007803",
    renavam: "01928374653",
    crlv_number: "CRLV-HRS-03",
    crlv_expiration: 1.year.from_now.to_date,
    driver_email: "fernando.alves@horuslog.com.br"
  },
  {
    plate: "HRS-4004",
    type: "Caminhão Basculante 6x4",
    brand: "Volkswagen",
    model: "Constellation 24.280",
    year: 2020,
    load_capacity_kg: 23000,
    current_mileage_km: 142000,
    status: "maintenance",
    chassis: "9BWCA1110FP007804",
    renavam: "01928374654",
    crlv_number: "CRLV-HRS-04",
    crlv_expiration: 3.days.ago.to_date, # CRLV vencido
    driver_email: nil
  }
]

vehicles = {}
vehicles_data.each do |vdata|
  driver_email = vdata.delete(:driver_email)
  vehicle = Vehicle.find_or_initialize_by(plate: vdata[:plate], company: horus)
  vehicle.assign_attributes(vdata)
  vehicle.save!
  vehicles[vehicle.plate] = vehicle
  puts "✓ Veículo: #{vehicle.plate} - #{vehicle.brand} #{vehicle.model} (#{vehicle.status})"

  if driver_email && (driver = drivers[driver_email])
    assignment = VehicleAssignment.find_or_initialize_by(vehicle: vehicle, driver: driver, unassigned_at: nil)
    assignment.assigned_at = 3.weeks.ago if assignment.new_record?
    assignment.save!
    puts "  ↳ Alocado para motorista: #{driver.name}"
  end
end

# 4. Máquinas Pesadas para Locação
machineries_data = [
  {
    name: "Escavadeira Hidráulica Komatsu PC200-8",
    category: "escavadeira",
    brand: "Komatsu",
    model: "PC200-8",
    year: 2023,
    serial_number: "KOMPC200-9912",
    hourly_rate: 210.00,
    daily_rate: 1600.00,
    status: "rented",
    notes: "Equipada com esteiras de alta tração e caçamba reforçada."
  },
  {
    name: "Retroescavadeira Caterpillar 416F2",
    category: "retroescavadeira",
    brand: "Caterpillar",
    model: "416F2",
    year: 2022,
    serial_number: "CAT416-8821",
    hourly_rate: 155.00,
    daily_rate: 1150.00,
    status: "available",
    notes: "Tração 4x4, linha hidráulica auxiliar frontal."
  },
  {
    name: "Pá Carregadeira Hyundai HL760-9",
    category: "pa_carregadeira",
    brand: "Hyundai",
    model: "HL760-9",
    year: 2021,
    serial_number: "HYU760-4412",
    hourly_rate: 195.00,
    daily_rate: 1450.00,
    status: "available",
    notes: "Capacidade da caçamba de 3.2m³ para movimentação pesada."
  },
  {
    name: "Rolo Compactador Dynapac CA250",
    category: "compactador",
    brand: "Dynapac",
    model: "CA250",
    year: 2020,
    serial_number: "DYN250-1190",
    hourly_rate: 170.00,
    daily_rate: 1250.00,
    status: "available",
    notes: "Compactação asfáltica e solos para terraplanagem."
  }
]

machineries = {}
machineries_data.each do |mdata|
  machinery = Machinery.find_or_initialize_by(serial_number: mdata[:serial_number], company: horus)
  machinery.assign_attributes(mdata)
  machinery.save!
  machineries[machinery.name] = machinery
  puts "✓ Máquina: #{machinery.name} (#{machinery.category}, R$ #{machinery.daily_rate}/dia)"
end

# 5. Contratos de Locação
rentals_data = [
  {
    code: "LOC-HRS-01",
    machinery_name: "Escavadeira Hidráulica Komatsu PC200-8",
    client_name: "Construtora Terra & Aço S.A.",
    rental_type: "daily",
    duration: 12,
    rate_applied: 1600.00,
    total_amount: 19200.00,
    start_date: 3.days.ago,
    end_date: 9.days.from_now,
    status: "active",
    delivery_address: "Avenida das Américas, 4200 - Barra da Tijuca, Rio de Janeiro - RJ",
    notes: "Operação de terraplanagem com seguro total da máquina incluso."
  },
  {
    code: "LOC-HRS-02",
    machinery_name: "Retroescavadeira Caterpillar 416F2",
    client_name: "Agroindústria Alvorada Ltda",
    rental_type: "hourly",
    duration: 35,
    rate_applied: 155.00,
    total_amount: 5425.00,
    start_date: 15.days.ago,
    end_date: 10.days.ago,
    status: "completed",
    delivery_address: "Fazenda Nova Aurora, Rod. BR-277 km 84, Curitiba - PR",
    notes: "Locação concluída e máquina inspecionada sem avarias."
  }
]

rentals_data.each do |rdata|
  machinery = machineries[rdata.delete(:machinery_name)]
  client = clients[rdata.delete(:client_name)]
  next unless machinery && client

  rental = MachineryRental.find_or_initialize_by(code: rdata[:code], company: horus)
  rental.assign_attributes(rdata)
  rental.machinery = machinery
  rental.client = client
  rental.save!
  puts "✓ Locação: #{rental.code} - #{machinery.name} para #{client.name} (R$ #{rental.total_amount})"
end

# 6. Viagens da Operação
trips_data = [
  {
    code: "TRP-H101",
    plate: "HRS-1001",
    driver_email: "roberto.mendes@horuslog.com.br",
    client_name: "Construtora Terra & Aço S.A.",
    origin: "São Paulo - SP (CD Lapa)",
    destination: "Rio de Janeiro - RJ (Porto Maravilha)",
    cargo_description: "32 Paletes de Estruturas Metálicas e Perfis de Aço",
    cargo_weight_kg: 29500,
    freight_value: 7800.00,
    distance_km: 430,
    status: "in_transit",
    started_at: 3.hours.ago,
    estimated_delivery_at: 4.hours.from_now,
    notes: "Carga com escolta na descida da Serra das Araras (Via Dutra)."
  },
  {
    code: "TRP-H102",
    plate: "HRS-2002",
    driver_email: "juliana.costa@horuslog.com.br",
    client_name: "Supermercados Estrela D'Alva",
    origin: "Campinas - SP (CD Anhanguera)",
    destination: "São Paulo - SP (Av. do Estado)",
    cargo_description: "Alimentos Secos, Bebidas e Enlatados",
    cargo_weight_kg: 22000,
    freight_value: 3900.00,
    distance_km: 95,
    status: "in_transit",
    started_at: 1.hour.ago,
    estimated_delivery_at: 1.hour.from_now,
    notes: "Descarregamento prioritário na doca 3 com agendamento."
  },
  {
    code: "TRP-H103",
    plate: "HRS-3003",
    driver_email: "fernando.alves@horuslog.com.br",
    client_name: "Distribuidora Horus Log Express",
    origin: "São Paulo - SP",
    destination: "Belo Horizonte - MG",
    cargo_description: "Peças Eletrônicas e Autopeças",
    cargo_weight_kg: 14500,
    freight_value: 6200.00,
    distance_km: 580,
    status: "delivered",
    started_at: 2.days.ago,
    delivered_at: 1.day.ago,
    estimated_delivery_at: 1.day.ago,
    notes: "Entrega pontual concluída. Comprovante fiscal digital assinado."
  },
  {
    code: "TRP-H104",
    plate: "HRS-1001",
    driver_email: "roberto.mendes@horuslog.com.br",
    client_name: "Agroindústria Alvorada Ltda",
    origin: "Santos - SP (Porto)",
    destination: "Curitiba - PR",
    cargo_description: "Adubos Químicos e Enxofre Técnico a Granel",
    cargo_weight_kg: 31000,
    freight_value: 8400.00,
    distance_km: 410,
    status: "scheduled",
    estimated_delivery_at: 2.days.from_now,
    notes: "Aguardando desembaraço aduaneiro no terminal de cargas."
  },
  {
    code: "TRP-H105",
    plate: "HRS-2002",
    driver_email: "juliana.costa@horuslog.com.br",
    client_name: "Supermercados Estrela D'Alva",
    origin: "São Paulo - SP",
    destination: "Santos - SP",
    cargo_description: "Laticínios e Produtos Refrigerados",
    cargo_weight_kg: 18000,
    freight_value: 3600.00,
    distance_km: 80,
    status: "not_delivered",
    status_reason: "quebra",
    started_at: 1.day.ago,
    notes: "Falha na correia do compressor e superaquecimento no km 42 da Anchieta."
  }
]

trips_data.each do |tdata|
  vehicle = vehicles[tdata.delete(:plate)]
  driver = drivers[tdata.delete(:driver_email)]
  client = clients[tdata[:client_name]]

  trip = Trip.find_or_initialize_by(code: tdata[:code], company: horus)
  trip.assign_attributes(tdata)
  trip.vehicle = vehicle
  trip.driver = driver
  trip.client = client
  trip.save!
  puts "✓ Viagem: #{trip.code} (#{trip.origin} → #{trip.destination}) [#{trip.status_human}]"

  # Se em trânsito, salva localização GPS
  if trip.status == "in_transit"
    DriverLocation.create!(
      company: horus,
      driver: driver,
      trip: trip,
      latitude: driver.current_latitude,
      longitude: driver.current_longitude,
      speed: 82.0,
      heading: 120.0,
      recorded_at: 3.minutes.ago
    )
  end

  # Se not_delivered, cria TripStatusUpdate
  if trip.status == "not_delivered"
    TripStatusUpdate.find_or_create_by!(
      company: horus,
      trip: trip,
      driver: driver,
      status: "not_delivered",
      reason: trip.status_reason || "quebra",
      notes: "Falha mecânica reportada pelo motorista. Guincho pesado acionado."
    )
  end
end

# 7. Abastecimentos
fuel_data = [
  {
    vehicle_plate: "HRS-1001",
    driver_email: "roberto.mendes@horuslog.com.br",
    current_mileage_km: 62400,
    liters: 350.0,
    total_amount: 2100.00,
    fuel_type: "diesel_s10",
    notes: "Posto Shell Rod. Presidente Dutra km 204."
  },
  {
    vehicle_plate: "HRS-2002",
    driver_email: "juliana.costa@horuslog.com.br",
    current_mileage_km: 88200,
    liters: 290.0,
    total_amount: 1740.00,
    fuel_type: "diesel_s10",
    notes: "Posto Ipiranga Rodoanel Mário Covas."
  },
  {
    vehicle_plate: "HRS-3003",
    driver_email: "fernando.alves@horuslog.com.br",
    current_mileage_km: 114000,
    liters: 180.0,
    total_amount: 1080.00,
    fuel_type: "diesel_s10",
    notes: "Posto Petrobras Fernão Dias km 48."
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
  refuel.company = horus
  refuel.assign_attributes(fdata)
  refuel.save!
  puts "✓ Abastecimento: #{v.plate} - #{refuel.liters}L #{refuel.fuel_type_human} (R$ #{refuel.total_amount})"
end

# 8. Notificações no Painel Web de Horus
notifications_data = [
  {
    title: "⚠️ Ocorrência em Rota: Viagem TRP-H105",
    message: "A motorista Juliana Costa reportou falha mecânica no trajeto SP → Santos.",
    notification_type: "incident",
    read: false
  },
  {
    title: "⛽ Novo Abastecimento Registrado",
    message: "O motorista Roberto Mendes abasteceu 350L de Diesel S-10 no caminhão HRS-1001.",
    notification_type: "fuel_refuel",
    read: false
  },
  {
    title: "🚨 Alerta de Documentação: CRLV e CNH",
    message: "A CNH do motorista Fernando Alves vence em 10 dias. O CRLV do caminhão HRS-2002 vence em 8 dias.",
    notification_type: "document_expiring",
    read: false
  },
  {
    title: "🚜 Contrato de Aluguel Ativo: LOC-HRS-01",
    message: "Locação da Escavadeira Komatsu PC200 iniciada para Construtora Terra & Aço.",
    notification_type: "system",
    read: true,
    read_at: 1.day.ago
  }
]

notifications_data.each do |ndata|
  n = Notification.find_or_initialize_by(title: ndata[:title], company: horus)
  n.assign_attributes(ndata)
  n.save!
  puts "✓ Notificação Web: #{n.title}"
end

# Notificações no App Mobile dos motoristas de Horus
drivers.each_value do |driver|
  DriverNotification.find_or_create_by!(
    driver: driver,
    company: horus,
    title: "Bem-vindo à frota Horus Logística!",
    message: "Seu aplicativo está configurado. Acompanhe suas viagens atribuídas e envie ocorrências e abastecimentos.",
    notification_type: "welcome",
    read: false
  )
end

puts "\n========================================================"
puts "🎉 DADOS DA EMPRESA HORUS POPULADOS COM SUCESSO!"
puts "========================================================"
