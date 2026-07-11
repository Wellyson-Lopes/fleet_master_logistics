import React, { createContext, useContext, useState, useEffect, ReactNode } from 'react';
import { storage } from '../services/storage';
import { authService, LoginResponse } from '../services/authService';

interface AuthContextData {
  signed: boolean;
  user: LoginResponse['data'] | null;
  loading: boolean;
  signIn(email: string, password: string): Promise<void>;
  signOut(): Promise<void>;
}

const AuthContext = createContext<AuthContextData>({} as AuthContextData);

export const AuthProvider: React.FC<{ children: ReactNode }> = ({ children }) => {
  const [user, setUser] = useState<LoginResponse['data'] | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    async function loadStorageData() {
      const storedToken = await storage.getToken();
      const storedUser = await storage.getUser();

      if (storedToken && storedUser) {
        setUser(storedUser);
      }
      setLoading(false);
    }

    loadStorageData();
  }, []);

  async function signIn(email: string, password: string) {
    try {
      const { user: userData, token } = await authService.login(email, password);
      
      if (token && userData) {
        await storage.saveToken(token);
        await storage.saveUser(userData);
        setUser(userData);
      } else {
        throw new Error('Falha na resposta da autenticação.');
      }
    } catch (error: any) {
      throw error;
    }
  }

  async function signOut() {
    try {
      await authService.logout();
    } catch (error) {
      console.log('Erro ao deslogar na API, mas prosseguindo com limpeza local.');
    } finally {
      await storage.clear();
      setUser(null);
    }
  }

  return (
    <AuthContext.Provider value={{ signed: !!user, user, loading, signIn, signOut }}>
      {children}
    </AuthContext.Provider>
  );
};

export const useAuth = () => useContext(AuthContext);
