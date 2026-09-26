# frozen_string_literal: true

puts "=== Buscando empresas com 'hous' ==="
companies = Company.where('name ILIKE ?', '%hous%')
if companies.empty?
  puts "Nenhuma empresa com 'hous'. Listando todas as empresas:"
  Company.all.each do |c|
    puts "ID: #{c.id} | Nome: #{c.name} | CNPJ: #{c.cnpj}"
  end
else
  companies.each do |c|
    puts "Encontrada: ID: #{c.id} | Nome: #{c.name} | CNPJ: #{c.cnpj}"
    puts 'Usuários vinculados:'
    c.users.each do |u|
      puts " - #{u.email} (Nome: #{u.name}, Admin: #{u.admin?})"
    end
  end
end
