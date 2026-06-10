# frozen_string_literal: true

# Concern responsável por aplicar o isolamento multi-tenant automaticamente nos modelos.
# Garante que todas as consultas respeitem o `company_id` do contexto atual (`Current.company`).
module TenantScoped
  extend ActiveSupport::Concern

  included do
    belongs_to :company
    validates :company_id, presence: true

    # Escopo global automático conforme diretrizes do projeto.
    # Filtra os registros com base no tenant armazenado em Current.company.
    default_scope -> { where(company_id: Current.company.id) if Current.company }
  end
end
