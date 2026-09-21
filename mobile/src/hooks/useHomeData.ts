import { useState, useEffect } from 'react';
import { useAuth } from '../context/AuthContext';
import { HOME_STRINGS } from '../screens/HomeScreen.constants';
import { KpiType } from '../components/styled/Kpi';
import api from '../api/client';

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
 * Centraliza a lógica de KPIs, Viagens e Alertas integrados à API.
 */
export const useHomeData = () => {
  const { user } = useAuth();
  const [activeTrip, setActiveTrip] = useState<TripData | null>(null);
  const [alerts, setAlerts] = useState<AlertData[]>([]);
  const [recentTrips, setRecentTrips] = useState<RecentTripData[]>([]);
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    let isMounted = true;

    async function loadHomeData() {
      try {
        setLoading(true);
        const response = await api.get('/api/v1/drivers/home_data');
        if (!isMounted) return;

        const data = response.data;
        if (data.active_trip) {
          const t = data.active_trip;
          const v = data.assigned_vehicle;
          setActiveTrip({
            plate: v?.plate || t.code,
            vehicle: v ? `${v.brand || ''} ${v.model || ''}`.trim() : t.code,
            client: t.client_name || data.company?.name || 'Cliente',
            load: `${t.cargo_description} (${t.cargo_weight_kg ? Number(t.cargo_weight_kg).toLocaleString('pt-BR') : 0} kg)`,
            kmRemaining: t.distance_km ? `${t.distance_km} km` : 'Em rota',
            deliveries: t.destination || 'Em trânsito',
            sla: t.status_human || 'Em rota',
          });
        } else if (data.assigned_vehicle) {
          const v = data.assigned_vehicle;
          setActiveTrip({
            plate: v.plate,
            vehicle: `${v.brand || ''} ${v.model || ''}`.trim() || v.plate,
            client: data.company?.name || 'Operação',
            load: v.type || 'Caminhão',
            kmRemaining: 'Disponível',
            deliveries: 'Pronto p/ rota',
            sla: '100%',
          });
        }
      } catch (error) {
        // Ignora silenciosamente caso a requisição falhe ou esteja em teste
      } finally {
        if (isMounted) setLoading(false);
      }
    }

    if (user) {
      loadHomeData();
    }

    return () => {
      isMounted = false;
    };
  }, [user]);

  const kpis: KpiItem[] = [
    { id: 'trips', label: HOME_STRINGS.kpis.trips_today, value: activeTrip ? '1' : '0', delta: HOME_STRINGS.kpis.states.none },
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
    loading,
  };
};
