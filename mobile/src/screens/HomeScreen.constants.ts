/**
 * Localização e Textos para a tela Home Mobile.
 * Centraliza todas as strings para evitar hardcoding nas views.
 */
export const HOME_STRINGS = {
  header: {
    greet: 'Bom dia,',
    default_user: 'Motorista',
  },
  alerts: {
    cta: 'Ver',
  },
  hero: {
    label: 'Viagem Ativa',
    no_trip_title: 'Nenhuma viagem em curso',
    no_trip_sub: 'Aguardando próxima escala...',
    stats: {
      km: 'km',
      deliveries: 'entregas',
      sla: 'prazo',
      empty_val: '--',
    },
    live_label: 'Rota',
  },
  kpis: {
    trips_today: 'Minhas viagens hoje',
    deliveries_week: 'Entregas/semana',
    incidents: 'Minhas ocorrências',
    efficiency: 'km/L este mês',
    states: {
      none: 'nenhuma',
      in_route: '1 em rota',
      on_track: 'na média',
      no_data: 'sem dados',
      up: '↑',
    }
  },
  recent_trips: {
    section_label: 'Minhas viagens recentes',
    empty_state_title: 'Nenhuma viagem registrada',
    empty_state_sub: 'Suas atividades aparecerão aqui',
  },
  auth: {
    logout: 'Sair do Aplicativo',
  }
} as const;
