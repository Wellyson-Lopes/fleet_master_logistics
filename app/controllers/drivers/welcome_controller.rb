# frozen_string_literal: true

module Drivers
  # Controller responsável por exibir a página de boas-vindas após a ativação da conta do motorista.
  # Fornece as instruções para download e uso do aplicativo móvel.
  class WelcomeController < ApplicationController
    # Exibe a página de confirmação de cadastro e links para as lojas de apps.
    #
    # @example URL
    #   GET /drivers/welcome
    #
    # @return [void]
    def index; end
  end
end
