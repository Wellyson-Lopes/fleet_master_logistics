# frozen_string_literal: true

puts "== Populando dados reais para o FleetMaster Logistics =="

# 1. Criação ou recuperação da empresa principal
company_cnpj = "12.345.678/0001-95"
unless CNPJ.valid?(company_cnpj)
  company_cnpj = CNPJ.generate(true)
end

company = Company.find_or_initialize_by(name: "TransLogística Brasil S.A.")
company.cnpj = company_cnpj if company.new_record? || !CNPJ.valid?(company.cnpj)
company.plan = "pro"
company.billing_cycle = "monthly"
company.subscription_status = "active"
company.trial_ends_at = 30.days.from_now
company.save!
puts "✓ Empresa: #{company.name} (CNPJ: #{company.cnpj}, Plano: #{company.plan_name_human})"

# 2. Usuário Administrador (Gestor da Frota)
admin_user = User.find_or_initialize_by(email: "admin@fleetmaster.com")
admin_user.name = "Wellyson Gestor Logístico"
admin_user.password = "password123"
admin_user.password_confirmation = "password123"
admin_user.company = company
admin_user.company_name = company.name
admin_user.cnpj = company.cnpj
admin_user.admin = true
admin_user.save!
puts "✓ Administrador: #{admin_user.email} (Senha: password123)"

# 3. Motoristas da Frota
drivers_data = [
  {
    name: "Carlos Eduardo Silva",
    email: "carlos.silva@translog.com.br",
    cpf: CPF.generate(true),
    cnh: "12345678900",
    cnh_expiration: 1.year.from_now,
    phone: "(11) 98765-4321",
    active: true
  },
  {
    name: "Marcos Roberto Rocha",
    email: "marcos.rocha@translog.com.br",
    cpf: CPF.generate(true),
    cnh: "23456789011",
    cnh_expiration: 20.days.from_now, # Alerta de expiração próxima
    phone: "(11) 97654-3210",
    active: true
  },
  {
    name: "Ana Paula Ferreira",
    email: "ana.ferreira@translog.com.br",
    cpf: CPF.generate(true),
    cnh: "34567890122",
    cnh_expiration: 2.years.from_now,
    phone: "(11) 96543-2109",
    active: true
  },
  {
    name: "José Vicente Santos",
    email: "jose.santos@translog.com.br",
    cpf: CPF.generate(true),
    cnh: "45678901233",
    cnh_expiration: 6.months.from_now,
    phone: "(11) 95432-1098",
    active: true
  }
]

drivers = {}
drivers_data.each do |data|
  driver = Driver.find_or_initialize_by(email: data[:email])
  driver.name = data[:name]
  driver.password = "password123"
  driver.password_confirmation = "password123"
  driver.company = company
  driver.cpf = data[:cpf] if driver.new_record? || driver.cpf.blank?
  driver.cnh = data[:cnh]
  driver.cnh_expiration = data[:cnh_expiration]
  driver.phone = data[:phone]
  driver.active = data[:active]
  driver.save!
  drivers[data[:email]] = driver
  puts "✓ Motorista: #{driver.name} (#{driver.email})"
end

# 4. Veículos da Frota
vehicles_data = [
  {
    plate: "BRA-2E19",
    type: "Caminhão Truck",
    brand: "Volvo",
    model: "FH 540 Globetrotter",
    year: 2023,
    load_capacity_kg: 24000,
    current_mileage_km: 54200,
    status: "active",
    driver_email: "carlos.silva@translog.com.br"
  },
  {
    plate: "RJZ-4B82",
    type: "Carreta Semirreboque",
    brand: "Scania",
    model: "R 450 Highline",
    year: 2022,
    load_capacity_kg: 32000,
    current_mileage_km: 91400,
    status: "active",
    driver_email: "ana.ferreira@translog.com.br"
  },
  {
    plate: "MGA-7C34",
    type: "Caminhão Truck",
    brand: "Mercedes-Benz",
    model: "Actros 2651",
    year: 2021,
    load_capacity_kg: 23000,
    current_mileage_km: 128900,
    status: "maintenance",
    driver_email: nil
  },
  {
    plate: "SPK-9D50",
    type: "VUC / Utilitário",
    brand: "Volkswagen",
    model: "Delivery 11.180",
    year: 2024,
    load_capacity_kg: 7500,
    current_mileage_km: 14800,
    status: "active",
    driver_email: "jose.santos@translog.com.br"
  }
]

vehicles_data.each do |vdata|
  driver_email = vdata.delete(:driver_email)
  vehicle = Vehicle.find_or_initialize_by(plate: vdata[:plate], company: company)
  vehicle.assign_attributes(vdata)
  vehicle.save!
  puts "✓ Veículo: #{vehicle.plate} - #{vehicle.brand} #{vehicle.model} (#{vehicle.status})"

  if driver_email && (driver = drivers[driver_email])
    assignment = VehicleAssignment.find_or_initialize_by(vehicle: vehicle, driver: driver, unassigned_at: nil)
    assignment.assigned_at = 2.weeks.ago if assignment.new_record?
    assignment.save!
    puts "  ↳ Alocado para motorista: #{driver.name}"
  end
end

# 5. Viagens e Cargas da Operação
trips_data = [
  {
    code: "TRP-8412",
    plate: "BRA-2E19",
    driver_email: "carlos.silva@translog.com.br",
    origin: "São Paulo - SP (CD Lapa)",
    destination: "Curitiba - PR (Parque Industrial)",
    client_name: "Construtora Andrade Gutierrez",
    cargo_description: "20 Paletes de Cimento e Vergalhões de Aço",
    cargo_weight_kg: 21500,
    freight_value: 6800.00,
    distance_km: 410,
    status: "in_transit",
    started_at: 4.hours.ago,
    estimated_delivery_at: 6.hours.from_now,
    notes: "Entrega prioritária no galpão 4 com descarregamento por empilhadeira."
  },
  {
    code: "TRP-8413",
    plate: "RJZ-4B82",
    driver_email: "ana.ferreira@translog.com.br",
    origin: "Porto de Santos - SP",
    destination: "Uberlândia - MG",
    client_name: "Cargill Agrícola S.A.",
    cargo_description: "Grãos de Soja e Farelo a Granel",
    cargo_weight_kg: 31000,
    freight_value: 9400.00,
    distance_km: 640,
    status: "in_transit",
    started_at: 8.hours.ago,
    estimated_delivery_at: 14.hours.from_now,
    notes: "Acompanhamento de peso na balança do km 210."
  },
  {
    code: "TRP-8410",
    plate: "SPK-9D50",
    driver_email: "jose.santos@translog.com.br",
    origin: "Campinas - SP",
    destination: "Ribeirão Preto - SP",
    client_name: "Atacadão Distribuição S.A.",
    cargo_description: "Bebidas e Alimentos Industrializados",
    cargo_weight_kg: 6800,
    freight_value: 3200.00,
    distance_km: 220,
    status: "delivered",
    started_at: 2.days.ago,
    delivered_at: 1.day.ago,
    estimated_delivery_at: 1.day.ago,
    notes: "Entrega realizada com sucesso. Canhoto de NF assinado."
  },
  {
    code: "TRP-8415",
    plate: "BRA-2E19",
    driver_email: "carlos.silva@translog.com.br",
    origin: "Curitiba - PR",
    destination: "Porto Alegre - RS",
    client_name: "Gerdau Aços Especiais",
    cargo_description: "Bobinas de Aço Laminado a Quente",
    cargo_weight_kg: 22000,
    freight_value: 7500.00,
    distance_km: 730,
    status: "scheduled",
    estimated_delivery_at: 3.days.from_now,
    notes: "Aguardando liberação de manifesto eletrônico (MDF-e)."
  }
]

trips_data.each do |tdata|
  vehicle = Vehicle.find_by!(plate: tdata.delete(:plate), company: company)
  driver = Driver.find_by!(email: tdata.delete(:driver_email), company: company)
  
  trip = Trip.find_or_initialize_by(code: tdata[:code], company: company)
  trip.assign_attributes(tdata)
  trip.vehicle = vehicle
  trip.driver = driver
  trip.save!
  puts "✓ Viagem: #{trip.code} (#{trip.origin} → #{trip.destination}) - #{trip.status_human} [R$ #{trip.freight_value}]"
end

puts "\n== Base de dados pronta e 100% operacional! =="
puts "Acesso Web Painel: admin@fleetmaster.com / password123"
puts "Acesso App Mobile Motorista: carlos.silva@translog.com.br / password123"
