import styled from 'styled-components/native';
import { LinearGradient } from 'expo-linear-gradient';
import { ScreenTitle, MetaText, SectionLabel, BodyText } from './Typography';

/**
 * Componentes de Card seguindo o Design System do FleetMaster.
 * Utilizados para agrupar informações com bordas e fundos padronizados.
 */

/** Card base translúcido para uso geral */
export const StyledCard = styled.View`
  background-color: ${({ theme }) => theme.colors.text.subtle20};
  border-width: 1px;
  border-color: ${({ theme }) => theme.colors.text.subtle25};
  border-radius: 14px;
  padding: 14px 16px;
`;

/** Card escuro sólido (Navy 800) para destaque ou formulários */
export const DarkCard = styled.View`
  background-color: ${({ theme }) => theme.colors.navy[800]};
  border-width: 1px;
  border-color: ${({ theme }) => theme.colors.text.subtle25};
  border-radius: 14px;
  padding: 14px 16px;
`;

/** Card de Login com preenchimento específico */
export const LoginFormCard = styled(DarkCard)`
  padding: 24px;
`;

/** Título da seção de login */
export const LoginTitle = styled(ScreenTitle)`
  font-size: 18px;
  margin-bottom: 4px;
`;

/** Subtítulo da seção de login */
export const LoginSub = styled(MetaText)`
  font-size: 12px;
  color: ${({ theme }) => theme.colors.text.subtle35};
  margin-bottom: 24px;
`;

/** Card branco sólido para dashboards e listas em modo light */
export const WhiteCard = styled.View`
  background-color: ${({ theme }) => theme.colors.white};
  border-width: 1px;
  border-color: ${({ theme }) => theme.colors.slate[100]};
  border-radius: 16px;
  shadow-color: rgba(15, 23, 42, 0.05);
  shadow-offset: 0px 1px;
  shadow-opacity: 1;
  shadow-radius: 3px;
  elevation: 1;
`;

/** Card de lista com bordas limpas */
export const ListCard = styled(WhiteCard)`
  overflow: hidden;
`;

/** Card com gradiente para destaques (Hero) */
export const GradientCard = styled(LinearGradient).attrs({
  start: { x: 0, y: 0 },
  end: { x: 1, y: 1 },
})`
  border-radius: 18px;
  padding: 16px;
  margin-bottom: 12px;
`;

/** Cabeçalho interno do card com layout horizontal (Flex-Row) */
export const CardHeader = styled.View`
  flex-direction: row;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 12px;
`;

/** Componentes Internos para HeroCards (Viagem Ativa) */

export const HeroTopRow = styled.View`
  flex-direction: row;
  justify-content: space-between;
  align-items: flex-start;
  margin-bottom: 10px;
`;

export const HeroLabel = styled(MetaText)`
  color: ${({ theme }) => theme.colors.text.white55};
  text-transform: uppercase;
  letter-spacing: 0.8px;
  margin-bottom: 3px;
`;

export const HeroTitle = styled(ScreenTitle)`
  font-size: 14px;
  margin-bottom: 2px;
`;

export const HeroSub = styled(MetaText)`
  color: ${({ theme }) => theme.colors.text.white50};
  margin-bottom: 12px;
`;

export const LiveChip = styled.View`
  flex-direction: row;
  align-items: center;
  background-color: ${({ theme }) => theme.colors.teal.subtleBg};
  border-width: 1px;
  border-color: ${({ theme }) => theme.colors.teal.subtleBorder};
  padding: 4px 10px;
  border-radius: 99px;
`;

export const LiveDot = styled.View`
  width: 6px;
  height: 6px;
  background-color: ${({ theme }) => theme.colors.teal[500]};
  border-radius: 3px;
  margin-right: 5px;
`;

export const LiveLabel = styled(MetaText)`
  font-size: 10px;
  font-weight: 700;
  color: ${({ theme }) => theme.colors.teal[500]};
`;

export const HeroStatsContainer = styled.View`
  flex-direction: row;
  justify-content: space-between;
`;

export const HeroStatItem = styled.View`
  background-color: ${({ theme }) => theme.colors.brand.white10};
  border-radius: 11px;
  padding: 8px 6px;
  flex: 1;
  margin: 0 3px;
  align-items: center;
`;

export const HeroStatValue = styled(ScreenTitle)`
  font-size: 16px;
  letter-spacing: -0.32px;
`;

export const HeroStatLabel = styled(MetaText)`
  font-size: 9px;
  color: ${({ theme }) => theme.colors.text.white50};
  margin-top: 1px;
`;

/** Componentes para Itens de Lista/Viagens Recentes */

export const HomeSectionLabel = styled(SectionLabel)`
  margin-bottom: 8px;
`;

export const RecentItemRow = styled.TouchableOpacity`
  flex-direction: row;
  align-items: center;
  padding: 10px 14px;
  border-bottom-width: 1px;
  border-bottom-color: ${({ theme }) => theme.colors.slate[100]};
`;

export const RecentIconBox = styled.View<{ bgColor: string }>`
  width: 36px;
  height: 36px;
  border-radius: 11px;
  background-color: ${props => props.bgColor};
  justify-content: center;
  align-items: center;
  margin-right: 10px;
`;

export const RecentMainInfo = styled.View`
  flex: 1;
`;

export const RecentIdText = styled(MetaText)`
  font-size: 10px;
  color: ${({ theme }) => theme.colors.slate[400]};
`;

export const RecentClientText = styled(BodyText)`
  font-size: 12px;
`;

export const RecentMetaInfo = styled(MetaText)`
  font-size: 10px;
  margin-top: 1px;
`;

/** Empty State Components */

export const EmptyStateContainer = styled.View`
  padding: 24px;
  align-items: center;
`;

export const EmptyStateTitle = styled(BodyText)`
  margin-top: 12px;
  color: ${({ theme }) => theme.colors.slate[400]};
`;

/** Container para o conteúdo principal do card */
export const CardBody = styled.View`
  /* Espaçamento customizado ou layout interno */
`;

/** Rodapé do card com divisor superior */
export const CardFooter = styled.View`
  margin-top: 12px;
  padding-top: 12px;
  border-top-width: 1px;
  border-top-color: ${({ theme }) => theme.colors.text.subtle20};
`;
