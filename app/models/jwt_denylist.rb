# frozen_string_literal: true

# Armazena tokens JWT revogados (denylist).
# Utilizado pela gem devise-jwt para invalidar sessões após o logout.
class JwtDenylist < ApplicationRecord
  include Devise::JWT::RevocationStrategies::Denylist

  self.table_name = 'jwt_denylists'
end
