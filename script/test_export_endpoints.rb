# frozen_string_literal: true

require_relative '../config/environment'

app = ActionDispatch::Integration::Session.new(Rails.application)
user = User.find_by(email: 'wellyson.dev@gmail.com') || User.find_by(email: 'admin@fleetmaster.com')
puts "Logando com: #{user.email} (Empresa: #{user.company.name})"

app.post '/users/sign_in', params: { user: { email: user.email, password: 'password123' } }
puts "Status login: #{app.response.status} -> Location: #{app.response.location}"

# Follow redirect se houver
if app.response.redirection?
  app.follow_redirect!
  puts "Apos redirect: #{app.response.status}"
end

app.get '/reports'
puts "Status GET /reports: #{app.response.status}"

app.get '/reports.csv'
puts "Status GET /reports.csv: #{app.response.status}"

app.get '/reports/print_pdf'
puts "Status GET /reports/print_pdf: #{app.response.status}"
