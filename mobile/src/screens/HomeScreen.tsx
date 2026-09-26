import React, { useState } from 'react';
import { StatusBar } from 'expo-status-bar';
import { View, Modal, Alert, ActivityIndicator, TouchableOpacity, ScrollView, Text } from 'react-native';
import { useTheme } from 'styled-components/native';
import { useAuth } from '../context/AuthContext';
import { useHomeData } from '../hooks/useHomeData';
import * as Icons from './HomeScreen.icons';
import { HOME_STRINGS } from './HomeScreen.constants';
import { PrimaryButton, TealButton, DangerButton, GhostButton, GhostButtonText, ButtonText } from '../components/styled/Button';
import { StyledInput, InputLabel } from '../components/styled/Input';
import { MetaText, ScreenTitle } from '../components/styled/Typography';
import api from '../api/client';
import { 
  WhiteCard, 
  GradientCard, 
  HeroTopRow, 
  HeroLabel, 
  HeroTitle, 
  HeroSub, 
  LiveChip, 
  LiveDot, 
  LiveLabel, 
  HeroStatsContainer, 
  HeroStatItem, 
  HeroStatValue, 
  HeroStatLabel, 
  HomeSectionLabel, 
  ListCard, 
  RecentItemRow, 
  RecentIconBox, 
  RecentMainInfo, 
  RecentIdText, 
  RecentClientText, 
  RecentMetaInfo, 
  EmptyStateContainer, 
  EmptyStateTitle 
} from '../components/styled/Card';
import { KpiGrid, KpiCard, KpiDeltaText } from '../components/styled/Kpi';
import { 
  MainHeader, 
  HeaderRow, 
  HeaderGreet, 
  RoundIconButton, 
  StatusBanner, 
  BannerText, 
  AlertCtaBadge, 
  AlertBadgeText 
} from '../components/styled/Header';
import { 
  ContentContainer, 
  HomeScrollContent, 
  ContentPadding, 
  LogoutSection 
} from '../components/styled/Layout';

export const HomeScreen = () => {
  const { signOut } = useAuth();
  const { userName, activeTrip, alerts, recentTrips, kpis, reload } = useHomeData();
  const theme = useTheme();

  // Estados de modais
  const [actionLoading, setActionLoading] = useState(false);
  const [refuelModalOpen, setRefuelModalOpen] = useState(false);
  const [incidentModalOpen, setIncidentModalOpen] = useState(false);
  const [notificationsModalOpen, setNotificationsModalOpen] = useState(false);
  const [notificationsList, setNotificationsList] = useState<any[]>([]);

  // Campos de abastecimento
  const [refuelMileage, setRefuelMileage] = useState('');
  const [refuelLiters, setRefuelLiters] = useState('');
  const [refuelAmount, setRefuelAmount] = useState('');
  const [refuelFuelType, setRefuelFuelType] = useState('diesel_s10');

  // Campos de incidente
  const [incidentReason, setIncidentReason] = useState('quebra');
  const [incidentNotes, setIncidentNotes] = useState('');

  // 1. Aceitar Viagem
  const handleAcceptTrip = async () => {
    if (!activeTrip?.id) return;
    setActionLoading(true);
    try {
      await api.post(`/api/v1/drivers/trips/${activeTrip.id}/accept`);
      Alert.alert('Sucesso', 'Viagem aceita com sucesso!');
      reload();
    } catch (err: any) {
      Alert.alert('Erro', err.response?.data?.error || 'Não foi possível aceitar a viagem.');
    } finally {
      setActionLoading(false);
    }
  };

  // 2. Iniciar Viagem
  const handleStartTrip = async () => {
    if (!activeTrip?.id) return;
    setActionLoading(true);
    try {
      await api.patch(`/api/v1/drivers/trips/${activeTrip.id}/status`, { status: 'in_transit' });
      Alert.alert('Boa Viagem!', 'Viagem iniciada. Rastreamento ativo.');
      reload();
    } catch (err: any) {
      Alert.alert('Erro', err.response?.data?.error || 'Falha ao iniciar viagem.');
    } finally {
      setActionLoading(false);
    }
  };

  // 3. Concluir Entrega
  const handleCompleteDelivery = async () => {
    if (!activeTrip?.id) return;
    setActionLoading(true);
    try {
      await api.patch(`/api/v1/drivers/trips/${activeTrip.id}/status`, { status: 'delivered' });
      Alert.alert('Parabéns!', 'Entrega confirmada com sucesso!');
      reload();
    } catch (err: any) {
      Alert.alert('Erro', err.response?.data?.error || 'Falha ao registrar entrega.');
    } finally {
      setActionLoading(false);
    }
  };

  // 4. Reportar Incidente / Não Entrega
  const handleReportIncident = async () => {
    if (!activeTrip?.id) return;
    setActionLoading(true);
    try {
      await api.patch(`/api/v1/drivers/trips/${activeTrip.id}/status`, {
        status: 'not_delivered',
        reason: incidentReason,
        notes: incidentNotes,
      });
      setIncidentModalOpen(false);
      setIncidentNotes('');
      Alert.alert('Ocorrência Registrada', 'A equipe operacional foi notificada.');
      reload();
    } catch (err: any) {
      Alert.alert('Erro', err.response?.data?.error || 'Falha ao enviar ocorrência.');
    } finally {
      setActionLoading(false);
    }
  };

  // 5. Registrar Abastecimento
  const handleSaveRefuel = async () => {
    if (!refuelMileage || !refuelLiters || !refuelAmount) {
      Alert.alert('Atenção', 'Preencha quilometragem, litros e valor.');
      return;
    }

    setActionLoading(true);
    try {
      await api.post('/api/v1/drivers/refuels', {
        refuel: {
          current_mileage_km: Number(refuelMileage),
          liters: Number(refuelLiters),
          total_amount: Number(refuelAmount),
          fuel_type: refuelFuelType,
        }
      });
      setRefuelModalOpen(false);
      setRefuelMileage('');
      setRefuelLiters('');
      setRefuelAmount('');
      Alert.alert('Sucesso', 'Abastecimento registrado!');
      reload();
    } catch (err: any) {
      Alert.alert('Erro', err.response?.data?.error || 'Não foi possível salvar abastecimento.');
    } finally {
      setActionLoading(false);
    }
  };

  // 6. Abrir Notificações
  const openNotifications = async () => {
    setNotificationsModalOpen(true);
    try {
      const res = await api.get('/api/v1/drivers/notifications');
      setNotificationsList(res.data?.notifications || []);
    } catch (err) {
      // ignore
    }
  };

  return (
    <ContentContainer>
      <StatusBar 
        style="light" 
        backgroundColor={theme.colors.navy[900]} 
      />
      
      <MainHeader>
        <HeaderRow>
          <View>
            <HeaderGreet>{HOME_STRINGS.header.greet}</HeaderGreet>
            <ScreenTitle>{userName}</ScreenTitle>
          </View>
          <RoundIconButton 
            accessibilityLabel="Ver notificações" 
            accessibilityRole="button"
            onPress={openNotifications}
          >
            <Icons.NotificationIcon />
          </RoundIconButton>
        </HeaderRow>

        {alerts.length > 0 && (
          <StatusBanner accessibilityLabel={`Alerta: ${alerts[0].message}`}>
            <Icons.AlertIcon />
            <BannerText>{alerts[0].message}</BannerText>
            <AlertCtaBadge accessibilityLabel={HOME_STRINGS.alerts.cta}>
              <AlertBadgeText>{HOME_STRINGS.alerts.cta}</AlertBadgeText>
              <Icons.ArrowRightIcon />
            </AlertCtaBadge>
          </StatusBanner>
        )}
      </MainHeader>

      <HomeScrollContent>
        <ContentPadding>
          {/* HERO CARD DA VIAGEM ATIVA */}
          <GradientCard colors={theme.gradients.primary}>
            <HeroTopRow>
              <View>
                <HeroLabel>{HOME_STRINGS.hero.label}</HeroLabel>
                <HeroTitle>{activeTrip ? `${activeTrip.plate} · ${activeTrip.vehicle}` : HOME_STRINGS.hero.no_trip_title}</HeroTitle>
                <HeroSub>{activeTrip ? `${activeTrip.client} · ${activeTrip.load}` : HOME_STRINGS.hero.no_trip_sub}</HeroSub>
              </View>
              {activeTrip && (
                <LiveChip>
                  <LiveDot />
                  <LiveLabel>{activeTrip.sla || HOME_STRINGS.hero.live_label}</LiveLabel>
                </LiveChip>
              )}
            </HeroTopRow>
            
            <HeroStatsContainer>
              <HeroStatItem>
                <HeroStatValue>{activeTrip ? activeTrip.kmRemaining : HOME_STRINGS.hero.stats.empty_val}</HeroStatValue>
                <HeroStatLabel>{HOME_STRINGS.hero.stats.km}</HeroStatLabel>
              </HeroStatItem>
              <HeroStatItem>
                <HeroStatValue>{activeTrip ? activeTrip.deliveries : HOME_STRINGS.hero.stats.empty_val}</HeroStatValue>
                <HeroStatLabel>{HOME_STRINGS.hero.stats.deliveries}</HeroStatLabel>
              </HeroStatItem>
              <HeroStatItem>
                <HeroStatValue>{activeTrip ? activeTrip.sla : HOME_STRINGS.hero.stats.empty_val}</HeroStatValue>
                <HeroStatLabel>{HOME_STRINGS.hero.stats.sla}</HeroStatLabel>
              </HeroStatItem>
            </HeroStatsContainer>
          </GradientCard>

          {/* BOTÕES DE AÇÃO DA VIAGEM ATIVA */}
          {activeTrip?.id && (
            <View style={{ marginTop: 12, marginBottom: 8, gap: 8 }}>
              {activeTrip.rawStatus === 'scheduled' && (
                <PrimaryButton fullWidth onPress={handleAcceptTrip} disabled={actionLoading}>
                  {actionLoading ? <ActivityIndicator color="#fff" /> : <ButtonText>✓ Aceitar Viagem Atribuída</ButtonText>}
                </PrimaryButton>
              )}

              {activeTrip.rawStatus === 'accepted' && (
                <TealButton fullWidth onPress={handleStartTrip} disabled={actionLoading}>
                  {actionLoading ? <ActivityIndicator color="#fff" /> : <ButtonText>🚚 Iniciar Viagem / Em Rota</ButtonText>}
                </TealButton>
              )}

              {activeTrip.rawStatus === 'in_transit' && (
                <View style={{ gap: 8 }}>
                  <TealButton fullWidth onPress={handleCompleteDelivery} disabled={actionLoading}>
                    {actionLoading ? <ActivityIndicator color="#fff" /> : <ButtonText>✓ Confirmar Entrega Realizada</ButtonText>}
                  </TealButton>
                  <DangerButton fullWidth onPress={() => setIncidentModalOpen(true)} disabled={actionLoading}>
                    <ButtonText>⚠️ Reportar Ocorrência / Incidente</ButtonText>
                  </DangerButton>
                </View>
              )}
            </View>
          )}

          {/* BOTÃO RÁPIDO DE ABASTECIMENTO */}
          <View style={{ marginTop: 8, marginBottom: 12 }}>
            <GhostButton fullWidth onPress={() => setRefuelModalOpen(true)}>
              <GhostButtonText>⛽ Registrar Abastecimento da Frota</GhostButtonText>
            </GhostButton>
          </View>

          {/* KPIS */}
          <KpiGrid>
            {kpis.map((kpi) => (
              <KpiCard key={kpi.id} type={kpi.id} value={kpi.value} label={kpi.label} delta={kpi.delta} />
            ))}
          </KpiGrid>

          {/* VIAGENS RECENTES */}
          <HomeSectionLabel>{HOME_STRINGS.recent_trips.section_label}</HomeSectionLabel>
          <ListCard>
            {recentTrips.length > 0 ? (
              recentTrips.map((trip, index) => (
                <RecentItemRow key={index} accessibilityLabel={`Viagem para ${trip.client}, status ${trip.status}`}>
                  <RecentIconBox bgColor={trip.bg}>
                    {trip.status === 'Em Rota' ? <Icons.TripRecentIcon /> : <Icons.IncidentRecentIcon />}
                  </RecentIconBox>
                  <RecentMainInfo>
                    <RecentIdText>{trip.id}</RecentIdText>
                    <RecentClientText>{trip.client}</RecentClientText>
                    <RecentMetaInfo>{trip.info}</RecentMetaInfo>
                  </RecentMainInfo>
                  <AlertCtaBadge bgColor={trip.bg}>
                     <KpiDeltaText color={trip.color}>{trip.status}</KpiDeltaText>
                  </AlertCtaBadge>
                </RecentItemRow>
              ))
            ) : (
              <EmptyStateContainer>
                <Icons.EmptyStateIcon />
                <EmptyStateTitle>{HOME_STRINGS.recent_trips.empty_state_title}</EmptyStateTitle>
                <MetaText>{HOME_STRINGS.recent_trips.empty_state_sub}</MetaText>
              </EmptyStateContainer>
            )}
          </ListCard>

          <LogoutSection>
            <DangerButton 
              fullWidth 
              onPress={signOut}
              accessibilityLabel="Sair da conta do motorista"
              accessibilityRole="button"
            >
              <ButtonText>{HOME_STRINGS.auth.logout}</ButtonText>
            </DangerButton>
          </LogoutSection>
        </ContentPadding>
      </HomeScrollContent>

      {/* MODAL: ABASTECIMENTO */}
      <Modal visible={refuelModalOpen} transparent animationType="slide">
        <View style={{ flex: 1, backgroundColor: 'rgba(0,0,0,0.6)', justifyContent: 'flex-end' }}>
          <View style={{ backgroundColor: theme.colors.white, borderTopLeftRadius: 24, borderTopRightRadius: 24, padding: 24 }}>
            <Text style={{ fontSize: 18, fontWeight: 'bold', color: theme.colors.navy[900], marginBottom: 16 }}>
              ⛽ Registrar Abastecimento
            </Text>

            <InputLabel>Odômetro Atual (km)</InputLabel>
            <StyledInput placeholder="Ex: 145200" keyboardType="number-pad" value={refuelMileage} onChangeText={setRefuelMileage} />

            <InputLabel style={{ marginTop: 12 }}>Litragem Abastecida (L)</InputLabel>
            <StyledInput placeholder="Ex: 120.5" keyboardType="decimal-pad" value={refuelLiters} onChangeText={setRefuelLiters} />

            <InputLabel style={{ marginTop: 12 }}>Valor Total Pago (R$)</InputLabel>
            <StyledInput placeholder="Ex: 750.00" keyboardType="decimal-pad" value={refuelAmount} onChangeText={setRefuelAmount} />

            <View style={{ marginTop: 20, gap: 8 }}>
              <PrimaryButton fullWidth onPress={handleSaveRefuel} disabled={actionLoading}>
                {actionLoading ? <ActivityIndicator color="#fff" /> : <ButtonText>Salvar Abastecimento</ButtonText>}
              </PrimaryButton>
              <GhostButton fullWidth onPress={() => setRefuelModalOpen(false)}>
                <GhostButtonText>Cancelar</GhostButtonText>
              </GhostButton>
            </View>
          </View>
        </View>
      </Modal>

      {/* MODAL: REPORTAR OCORRÊNCIA */}
      <Modal visible={incidentModalOpen} transparent animationType="slide">
        <View style={{ flex: 1, backgroundColor: 'rgba(0,0,0,0.6)', justifyContent: 'flex-end' }}>
          <View style={{ backgroundColor: theme.colors.white, borderTopLeftRadius: 24, borderTopRightRadius: 24, padding: 24 }}>
            <Text style={{ fontSize: 18, fontWeight: 'bold', color: theme.colors.red[500], marginBottom: 16 }}>
              ⚠️ Reportar Ocorrência na Rota
            </Text>

            <InputLabel>Motivo do Incidente</InputLabel>
            <View style={{ flexDirection: 'row', flexWrap: 'wrap', gap: 6, marginBottom: 12, marginTop: 4 }}>
              {[
                { id: 'quebra', label: 'Falha Mecânica' },
                { id: 'acidente', label: 'Acidente' },
                { id: 'cliente_ausente', label: 'Cliente Ausente' },
                { id: 'outro', label: 'Outro' },
              ].map((item) => (
                <TouchableOpacity
                  key={item.id}
                  onPress={() => setIncidentReason(item.id)}
                  style={{
                    paddingHorizontal: 12,
                    paddingVertical: 8,
                    borderRadius: 8,
                    backgroundColor: incidentReason === item.id ? theme.colors.red[500] : theme.colors.slate[100],
                  }}
                >
                  <Text style={{ color: incidentReason === item.id ? '#fff' : theme.colors.slate[900], fontSize: 12, fontWeight: 'bold' }}>
                    {item.label}
                  </Text>
                </TouchableOpacity>
              ))}
            </View>

            <InputLabel>Observações / Detalhes</InputLabel>
            <StyledInput 
              placeholder="Descreva o que aconteceu..." 
              value={incidentNotes} 
              onChangeText={setIncidentNotes} 
              multiline 
              numberOfLines={3} 
            />

            <View style={{ marginTop: 20, gap: 8 }}>
              <DangerButton fullWidth onPress={handleReportIncident} disabled={actionLoading}>
                {actionLoading ? <ActivityIndicator color="#fff" /> : <ButtonText>Confirmar e Notificar Empresa</ButtonText>}
              </DangerButton>
              <GhostButton fullWidth onPress={() => setIncidentModalOpen(false)}>
                <GhostButtonText>Cancelar</GhostButtonText>
              </GhostButton>
            </View>
          </View>
        </View>
      </Modal>

      {/* MODAL: NOTIFICAÇÕES */}
      <Modal visible={notificationsModalOpen} transparent animationType="slide">
        <View style={{ flex: 1, backgroundColor: 'rgba(0,0,0,0.6)', justifyContent: 'flex-end' }}>
          <View style={{ backgroundColor: theme.colors.white, borderTopLeftRadius: 24, borderTopRightRadius: 24, padding: 24, maxHeight: '80%' }}>
            <Text style={{ fontSize: 18, fontWeight: 'bold', color: theme.colors.navy[900], marginBottom: 16 }}>
              🔔 Notificações do Motorista
            </Text>

            <ScrollView style={{ maxHeight: 300 }}>
              {notificationsList.length > 0 ? (
                notificationsList.map((n: any, idx: number) => (
                  <View key={idx} style={{ paddingVertical: 10, borderBottomWidth: 1, borderColor: '#eee' }}>
                    <Text style={{ fontWeight: 'bold', color: theme.colors.navy[900], fontSize: 14 }}>{n.title}</Text>
                    <Text style={{ color: theme.colors.slate[500], fontSize: 12, marginTop: 2 }}>{n.message}</Text>
                  </View>
                ))
              ) : (
                <Text style={{ color: theme.colors.slate[400], textAlign: 'center', paddingVertical: 20 }}>
                  Nenhuma notificação nova.
                </Text>
              )}
            </ScrollView>

            <View style={{ marginTop: 20 }}>
              <GhostButton fullWidth onPress={() => setNotificationsModalOpen(false)}>
                <GhostButtonText>Fechar</GhostButtonText>
              </GhostButton>
            </View>
          </View>
        </View>
      </Modal>
    </ContentContainer>
  );
};
