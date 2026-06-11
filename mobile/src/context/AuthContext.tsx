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
      const token = await storage.getToken();

      if (token) {
        try {
          // Valida o token buscando o perfil atual
          const profile = await authService.getProfile();
          setUser(profile);
        } catch (error) {
          // Em produção, falhas de rede ou token expirado apenas limpam o estado
          await storage.removeToken();
        }
      }
      setLoading(false);
    }

    loadStorageData();
  }, []);

  async function signIn(email: string, password: string) {
    try {
      const { user, token } = await authService.login(email, password);
      
      if (token) {
        await storage.saveToken(token);
        setUser(user);
      }
    } catch (error: any) {
      // Repassa o erro para o componente tratar (ex: LoginScreen) sem expor no console
      throw error;
    }
  }

  async function signOut() {
    try {
      await authService.logout();
    } finally {
      await storage.removeToken();
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
