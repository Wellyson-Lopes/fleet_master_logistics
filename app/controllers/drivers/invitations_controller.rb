# frozen_string_literal: true

module Drivers
  # Controller que gerencia o fluxo de ativação de conta (convite) dos motoristas via interface Web.
  # Garante que o motorista complete seu cadastro mas não permaneça logado no navegador.
  class InvitationsController < Devise::InvitationsController
    # Processa a atualização da senha e dados profissionais do motorista.
    # Após o sucesso, desloga o recurso para impedir acesso ao dashboard web.
    #
    # @example URL
    #   PUT /drivers/invitation
    #
    # @return [void]
    def update
      super do |resource|
        if resource.errors.empty?
          # TRAVA DE SEGURANÇA: Desloga imediatamente qualquer sessão web que o Devise tenha tentado criar
          sign_out(resource)

          # Redireciona para a página de boas vindas com instruções do App
          flash[:notice] = 'Conta ativada com sucesso! Agora utilize o aplicativo móvel.'
          respond_with resource, location: drivers_welcome_path
          return
        end
      end
    end

    protected

    # Define o caminho de redirecionamento após o aceite do convite.
    #
    # @param _resource [Driver] O motorista que aceitou o convite
    #
    # @return [String] Caminho da página de boas-vindas
    def after_accept_path_for(_resource)
      drivers_welcome_path
    end
  end
end
