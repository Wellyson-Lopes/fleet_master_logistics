import * as SecureStore from 'expo-secure-store';

/**
 * Nomes das chaves utilizadas para persistência segura.
 */
const TOKEN_KEY = 'auth_token';
const USER_KEY = 'auth_user';

/**
 * Persiste o token JWT de forma segura no dispositivo.
 * @param token Token JWT recebido da API
 */
export const saveToken = async (token: string) => {
  await SecureStore.setItemAsync(TOKEN_KEY, token);
};

/**
 * Recupera o token JWT do armazenamento seguro.
 * @returns Token JWT ou null se não encontrado
 */
export const getToken = async () => {
  return await SecureStore.getItemAsync(TOKEN_KEY);
};

/**
 * Remove apenas o token JWT do armazenamento.
 */
export const removeToken = async () => {
  await SecureStore.deleteItemAsync(TOKEN_KEY);
};

/**
 * Persiste os dados do usuário (serializados em JSON) de forma segura.
 * @param user Objeto de dados do motorista
 */
export const saveUser = async (user: Record<string, unknown>) => {
  await SecureStore.setItemAsync(USER_KEY, JSON.stringify(user));
};

/**
 * Recupera e desserializa os dados do usuário do armazenamento.
 * @returns Objeto do usuário ou null se não encontrado
 */
export const getUser = async () => {
  const user = await SecureStore.getItemAsync(USER_KEY);
  return user ? JSON.parse(user) : null;
};

/**
 * Limpa todos os dados de autenticação (Token e Usuário) do dispositivo.
 */
export const clearStorage = async () => {
  await SecureStore.deleteItemAsync(TOKEN_KEY);
  await SecureStore.deleteItemAsync(USER_KEY);
};

/**
 * Objeto consolidado para compatibilidade com versões anteriores e facilidade de uso.
 */
export const storage = {
  saveToken,
  getToken,
  removeToken,
  saveUser,
  getUser,
  clear: clearStorage
};
