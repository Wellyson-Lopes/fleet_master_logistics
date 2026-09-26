# frozen_string_literal: true

c = Company.find_by('name ILIKE ?', '%horus%')
puts "Empresa: #{c.name} (#{c.id})"
puts "CNPJ: #{c.cnpj}"
puts "Plano: #{c.plan} | Status: #{c.subscription_status}"

puts "\n--- Usuários ---"
c.users.each do |u|
  puts "Email: #{u.email} | Nome: #{u.name} | Admin: #{u.admin?} | ID: #{u.id}"
end

puts "\n--- Motoristas ---"
c.drivers.each do |d|
  puts "Email: #{d.email} | Nome: #{d.name} | CPF: #{d.cpf} | CNH: #{d.cnh} | Ativo: #{d.active}"
end

puts "\n--- Veículos ---"
c.vehicles.each do |v|
  puts "Placa: #{v.plate} | Tipo: #{v.type} | Status: #{v.status}"
end

puts "\n--- Viagens ---"
c.trips.each do |t|
  puts "Código: #{t.code} | Destino: #{t.destination} | Status: #{t.status}"
end

puts "\n--- Clientes ---"
c.clients.each do |cl|
  puts "Cliente: #{cl.name}"
end

puts "\n--- Máquinas ---"
c.machineries.each do |m|
  puts "Máquina: #{m.name}"
end

puts "\n--- Locações ---"
c.machinery_rentals.each do |r|
  puts "Locação: #{r.code}"
end
