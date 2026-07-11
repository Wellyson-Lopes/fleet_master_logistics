# frozen_string_literal: true

# Gerencia atributos globais por thread para a requisição atual.
# Utilizado primariamente para armazenar o contexto do Tenant (company) e do usuário logado.
class Current < ActiveSupport::CurrentAttributes
  attribute :company
  attribute :user
end
