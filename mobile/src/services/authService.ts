import api from '../api/client';

/**
 * Interface para a resposta de login da API Rails.
 */
export interface LoginResponse {
  status: {
    /** Código de status HTTP (ex: 200, 401) */
    code: number;
    /** Mensagem amigável retornada pela API */
    message: string;
  };
  data: {
    /** UUID único do motorista */
    id: string;
    /** E-mail de acesso */
    email: string;
    /** Nome completo do motorista (pode ser nulo se não preenchido) */
    name: string | null;
    /** CNPJ da transportadora vinculada */
    cnpj?: string;
    /** CPF do motorista */
    cpf?: string;
    /** Número da CNH */
    cnh?: string;
    /** Status de ativação no sistema */
    active?: boolean;
  };
}

/**
 * Serviço de autenticação especializado para o módulo do motorista.
 * Gerencia chamadas de login, perfil e logout na API do FleetMaster.
 */
export const authService = {
  /**
   * Realiza a autenticação do motorista utilizando e-mail e senha.
   * O Token JWT é extraído do cabeçalho 'Authorization' da resposta.
   * 
   * @param email E-mail ou Usuário do motorista
   * @param password Senha de acesso
   * @returns Objeto contendo os dados do usuário e o token JWT
   */
  async login(email: string, password: string): Promise<{ user: LoginResponse['data']; token: string | undefined }> {
    const response = await api.post<LoginResponse>('/api/v1/drivers/login', {
      driver: { email, password },
    });

    const headers = response.headers;
    const token = headers['authorization'] || headers['Authorization'];

    if (!token) {
      throw new Error('Token não encontrado na resposta da API.');
    }

    return {
      user: response.data.data,
      token,
    };
  },

  /**
   * Busca os dados atualizados do perfil do motorista autenticado.
   * Requer que o token JWT esteja presente no cabeçalho via interceptor.
   * 
   * @returns Dados do perfil do motorista
   */
  async getProfile(): Promise<LoginResponse['data']> {
    const response = await api.get<LoginResponse>('/api/v1/drivers/profile');
    return response.data.data;
  },

  /**
   * Solicita a revogação do token JWT no servidor (Logout remoto).
   */
  async logout() {
    await api.delete('/api/v1/drivers/logout');
  },
};
