# frozen_string_literal: true

require 'rails_helper'

user = User.find_by(email: 'admin@fleetmaster.com')
puts "User: #{user&.email}"
company = user.company
puts "Company: #{company&.name}"

ReportsController.new
puts 'ReportsController exists'
