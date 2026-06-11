import axios, { InternalAxiosRequestConfig } from 'axios';
import { storage } from '../services/storage';

/**
 * Cliente Axios configurado para a API do FleetMaster.
 * 
 * ATENÇÃO: 
 * - No Emulador Android: use 'http://10.0.2.2:3000'
 * - No Dispositivo Físico: use o IP da sua máquina (ex: 'http://192.168.1.5:3000')
 * - No Emulador iOS: 'http://localhost:3000' funciona.
 */
const api = axios.create({
  baseURL: 'http://192.168.1.5:3000', 
  headers: {
    'Content-Type': 'application/json',
    Accept: 'application/json',
  },
});

// Interceptor para adicionar o Token em todas as requisições
api.interceptors.request.use(async (config: InternalAxiosRequestConfig) => {
  const token = await storage.getToken();
  if (token && config.headers) {
    config.headers.Authorization = token;
  }
  return config;
});

export default api;
