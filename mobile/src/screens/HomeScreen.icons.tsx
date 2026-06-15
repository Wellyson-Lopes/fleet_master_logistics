import React from 'react';
import { useTheme } from 'styled-components/native';
import { 
  Route, 
  PackageCheck, 
  AlertTriangle, 
  Fuel, 
  Bell, 
  AlertCircle, 
  ClipboardList, 
  Truck,
  ArrowRight
} from 'lucide-react-native';

export const TripIcon = () => {
  const theme = useTheme();
  return <Route size={16} color={theme.colors.blue[500]} strokeWidth={2} />;
};

export const DeliveryIcon = () => {
  const theme = useTheme();
  return <PackageCheck size={16} color={theme.colors.green[500]} strokeWidth={2} />;
};

export const IncidentIcon = () => {
  const theme = useTheme();
  return <AlertTriangle size={16} color={theme.colors.amber[500]} strokeWidth={2} />;
};

export const EfficiencyIcon = () => {
  const theme = useTheme();
  return <Fuel size={16} color={theme.colors.teal[500]} strokeWidth={2} />;
};

export const NotificationIcon = () => {
  const theme = useTheme();
  return <Bell size={18} color={theme.colors.text.subtle35} strokeWidth={1.8} />;
};

export const AlertIcon = () => {
  const theme = useTheme();
  return <AlertTriangle size={16} color={theme.colors.amber[500]} strokeWidth={2} />;
};

export const EmptyStateIcon = () => {
  const theme = useTheme();
  return <ClipboardList size={40} color={theme.colors.slate[200]} strokeWidth={1.5} />;
};

export const TripRecentIcon = () => {
  const theme = useTheme();
  return <Truck size={17} color={theme.colors.blue[500]} strokeWidth={1.8} />;
};

export const IncidentRecentIcon = () => {
  const theme = useTheme();
  return <AlertCircle size={17} color={theme.colors.red[500]} strokeWidth={1.8} />;
};

export const ArrowRightIcon = () => {
  const theme = useTheme();
  return <ArrowRight size={14} color={theme.colors.amber[500]} strokeWidth={2} />;
};
