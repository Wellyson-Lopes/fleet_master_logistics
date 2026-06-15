import { useAuth } from '../context/AuthContext';
import { HOME_STRINGS } from '../screens/HomeScreen.constants';
import { KpiType } from '../components/styled/Kpi';

export interface TripData { 
  plate: string; 
  vehicle: string; 
  client: string; 
  load: string; 
  kmRemaining: string; 
  deliveries: string; 
  sla: string; 
}

export interface AlertData { 
  id: string; 
  message: string; 
}

export interface RecentTripData { 
  id: string; 
  client: string; 
  info: string; 
  status: string; 
  color: string; 
  bg: string; 
}

export interface KpiItem {
  id: KpiType;
  label: string;
  value: string;
  delta: string;
}

/**
 * Hook customizado para gerenciar os dados da tela Home.
 * Centraliza a lógica de KPIs, Viagens e Alertas.
 */
export const useHomeData = () => {
  const { user } = useAuth();

  // DADOS (Posteriormente virão de APIs via React Query/SWR)
  // Usamos casting para que o TS não infira 'never' em constantes nulas mockadas
  const activeTrip = null as TripData | null; 
  const alerts = [] as AlertData[]; 
  const recentTrips = [] as RecentTripData[]; 

  const kpis: KpiItem[] = [
    { id: 'trips', label: HOME_STRINGS.kpis.trips_today, value: '0', delta: HOME_STRINGS.kpis.states.none },
    { id: 'deliveries', label: HOME_STRINGS.kpis.deliveries_week, value: '0', delta: '0' },
    { id: 'incidents', label: HOME_STRINGS.kpis.incidents, value: '0', delta: 'em dia' },
    { id: 'efficiency', label: HOME_STRINGS.kpis.efficiency, value: '-', delta: HOME_STRINGS.kpis.states.no_data },
  ];

  return {
    userName: user?.name || user?.email || HOME_STRINGS.header.default_user,
    activeTrip,
    alerts,
    recentTrips,
    kpis,
  };
};
