import React from 'react';
import styled, { useTheme } from 'styled-components/native';
import { WhiteCard } from './Card';
import { ScreenTitle, MetaText } from './Typography';
import * as Icons from '../../screens/HomeScreen.icons';

/**
 * Componentes de KPI seguindo o Design System do FleetMaster.
 * Centralizados para reuso em dashboards e relatórios.
 */

export const KpiGrid = styled.View`
  flex-direction: row;
  flex-wrap: wrap;
  justify-content: space-between;
  margin-bottom: 14px;
`;

export const StyledKpiCard = styled(WhiteCard)`
  width: 48.5%;
  padding: 12px;
  margin-bottom: 10px;
`;

export const KpiIconBase = styled.View<{ bgColor: string }>`
  width: 32px;
  height: 32px;
  border-radius: 10px;
  background-color: ${props => props.bgColor};
  justify-content: center;
  align-items: center;
  margin-bottom: 8px;
`;

export const KpiValueText = styled(ScreenTitle)`
  color: ${({ theme }) => theme.colors.slate[900]};
  font-size: 22px;
  letter-spacing: -0.88px;
  line-height: 22px;
`;

export const KpiDeltaBadge = styled.View<{ bgColor: string }>`
  align-self: flex-start;
  padding: 2px 7px;
  border-radius: 99px;
  background-color: ${props => props.bgColor};
  margin-top: 5px;
`;

export const KpiDeltaText = styled(MetaText)<{ color: string }>`
  font-size: 9px;
  font-weight: 700;
  color: ${props => props.color};
`;

/** KPI COMPONENT */

export type KpiType = 'trips' | 'deliveries' | 'incidents' | 'efficiency';

interface KpiCardProps {
  type: KpiType;
  value: string;
  label: string;
  delta: string;
}

export const KpiCard: React.FC<KpiCardProps> = ({ type, value, label, delta }) => {
  const theme = useTheme();
  
  const configs = {
    trips: { 
      bg: theme.colors.blue[50], 
      dBg: theme.colors.blue[50], 
      dColor: theme.colors.blue[500], 
      Icon: Icons.TripIcon 
    },
    deliveries: { 
      bg: theme.colors.teal[50], 
      dBg: theme.colors.teal[50], 
      dColor: theme.colors.green[500], 
      Icon: Icons.DeliveryIcon 
    },
    incidents: { 
      bg: theme.colors.amber[100], 
      dBg: theme.colors.amber[100], 
      dColor: theme.colors.amber[500], 
      Icon: Icons.IncidentIcon 
    },
    efficiency: { 
      bg: theme.colors.teal[50], 
      dBg: theme.colors.teal[50], 
      dColor: theme.colors.teal[500], 
      Icon: Icons.EfficiencyIcon 
    }
  };
  
  const config = configs[type];

  return (
    <StyledKpiCard>
      <KpiIconBase bgColor={config.bg}><config.Icon /></KpiIconBase>
      <KpiValueText>{value}</KpiValueText>
      <MetaText style={{ marginTop: 3 }}>{label}</MetaText>
      <KpiDeltaBadge bgColor={config.dBg}>
        <KpiDeltaText color={config.dColor}>{delta}</KpiDeltaText>
      </KpiDeltaBadge>
    </StyledKpiCard>
  );
};
