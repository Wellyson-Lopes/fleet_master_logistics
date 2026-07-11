# frozen_string_literal: true

# Concern responsável por aplicar o isolamento multi-tenant automaticamente nos modelos.
# Garante que todas as consultas respeitem o `company_id` do contexto atual (`Current.company`).
# Nota: O default_scope só aplica o filtro quando Current.company está definido. Durante
# fluxos de autenticação (login, sign-up, convite), o Current.company ainda não foi
# setado — o scope retorna nil (sem filtro), permitindo que o Devise encontre o registro.
# Após a autenticação, set_current_tenant define Current.company e o isolamento entra em ação.
module TenantScoped
  extend ActiveSupport::Concern

  included do
    belongs_to :company
    validates :company, presence: true

    # Escopo global automático: filtra por company_id quando há tenant definido.
    # Quando Current.company é nil (ex: durante autenticação), retorna sem filtro
    # para não bloquear o Devise.
    default_scope -> { where(company_id: Current.company.id) if Current.company }
  end
end
