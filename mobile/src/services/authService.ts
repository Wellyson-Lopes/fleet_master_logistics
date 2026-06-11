import api from '../api/client';

/**
 * Interface para a resposta de login da API Rails.
 */
export interface LoginResponse {
  status: {
    code: number;
    message: string;
  };
  data: {
    id: string;
    email: string;
    name: string | null;
  };
}

/**
 * Serviço de autenticação para motoristas.
 */
export const authService = {
  /**
   * Realiza o login do motorista.
   * O Token JWT é retornado no cabeçalho 'Authorization' pela API.
   */
  async login(email: string, password: string): Promise<{ user: LoginResponse['data']; token: string | undefined }> {
    const response = await api.post<LoginResponse>('/api/v1/drivers/login', {
      driver: { email, password },
    });

    const token = response.headers.authorization;
    return {
      user: response.data.data,
      token,
    };
  },

  /**
   * Busca os dados do perfil do motorista autenticado.
   */
  async getProfile(): Promise<LoginResponse['data']> {
    const response = await api.get<LoginResponse>('/api/v1/drivers/profile');
    return response.data.data;
  },

  /**
   * Realiza o logout revogando o token na API.
   */
  async logout() {
    await api.delete('/api/v1/drivers/logout');
  },
};
