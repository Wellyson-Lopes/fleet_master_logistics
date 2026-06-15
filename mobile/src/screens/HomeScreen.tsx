import React from 'react';
import { StatusBar } from 'expo-status-bar';
import { View } from 'react-native';
import { useTheme } from 'styled-components/native';
import { useAuth } from '../context/AuthContext';
import { useHomeData } from '../hooks/useHomeData';
import * as Icons from './HomeScreen.icons';
import { HOME_STRINGS } from './HomeScreen.constants';
import { DangerButton, ButtonText } from '../components/styled/Button';
import { MetaText, ScreenTitle } from '../components/styled/Typography';
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

// =============================================================================
// VIEW PRINCIPAL (Puramente Declarativa - Zero Estilo Inline)
// =============================================================================

export const HomeScreen = () => {
  const { signOut } = useAuth();
  const { userName, activeTrip, alerts, recentTrips, kpis } = useHomeData();
  const theme = useTheme();

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
          >
            <Icons.NotificationIcon />
          </RoundIconButton>
        </HeaderRow>

        {alerts.length > 0 && (
          <StatusBanner accessibilityLabel={`Alerta crítico: ${alerts[0].message}`}>
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
          {/* HERO CARD */}
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
                  <LiveLabel>{HOME_STRINGS.hero.live_label}</LiveLabel>
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

          <KpiGrid>
            {kpis.map((kpi) => (
              <KpiCard key={kpi.id} type={kpi.id} value={kpi.value} label={kpi.label} delta={kpi.delta} />
            ))}
          </KpiGrid>

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
    </ContentContainer>
  );
};
