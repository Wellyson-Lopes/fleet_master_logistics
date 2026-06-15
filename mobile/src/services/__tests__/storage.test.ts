import * as SecureStore from 'expo-secure-store';
import { saveToken, getToken, removeToken, saveUser, getUser, clearStorage } from '../storage';

jest.mock('expo-secure-store', () => ({
  setItemAsync: jest.fn(),
  getItemAsync: jest.fn(),
  deleteItemAsync: jest.fn(),
}));

describe('Storage Service', () => {
  beforeEach(() => {
    jest.clearAllMocks();
  });

  it('deve salvar o token corretamente', async () => {
    await saveToken('fake-token');
    expect(SecureStore.setItemAsync).toHaveBeenCalledWith('auth_token', 'fake-token');
  });

  it('deve recuperar o token corretamente', async () => {
    (SecureStore.getItemAsync as jest.Mock).mockResolvedValue('retrieved-token');
    const token = await getToken();
    expect(token).toBe('retrieved-token');
    expect(SecureStore.getItemAsync).toHaveBeenCalledWith('auth_token');
  });

  it('deve remover o token corretamente', async () => {
    await removeToken();
    expect(SecureStore.deleteItemAsync).toHaveBeenCalledWith('auth_token');
  });

  it('deve salvar o usuário como string JSON', async () => {
    const user = { id: '1', name: 'Teste' };
    await saveUser(user);
    expect(SecureStore.setItemAsync).toHaveBeenCalledWith('auth_user', JSON.stringify(user));
  });

  it('deve recuperar e parsear o usuário corretamente', async () => {
    const user = { id: '1', name: 'Teste' };
    (SecureStore.getItemAsync as jest.Mock).mockResolvedValue(JSON.stringify(user));
    const retrievedUser = await getUser();
    expect(retrievedUser).toEqual(user);
  });

  it('deve retornar null se não houver usuário no storage', async () => {
    (SecureStore.getItemAsync as jest.Mock).mockResolvedValue(null);
    const retrievedUser = await getUser();
    expect(retrievedUser).toBeNull();
  });

  it('deve limpar todo o storage', async () => {
    await clearStorage();
    expect(SecureStore.deleteItemAsync).toHaveBeenCalledTimes(2);
    expect(SecureStore.deleteItemAsync).toHaveBeenCalledWith('auth_token');
    expect(SecureStore.deleteItemAsync).toHaveBeenCalledWith('auth_user');
  });
});
