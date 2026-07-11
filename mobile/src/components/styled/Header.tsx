import styled from 'styled-components/native';
import { MetaText } from './Typography';

/**
 * Componentes de Cabeçalho e Banners de Alerta.
 * Seguindo o padrão Navy 900 para fundos escuros.
 */

export const MainHeader = styled.View`
  background-color: ${({ theme }) => theme.colors.navy[900]};
  padding: 50px 16px 16px;
  flex-shrink: 0;
`;

export const HeaderRow = styled.View`
  flex-direction: row;
  justify-content: space-between;
  align-items: center;
`;

export const HeaderGreet = styled(MetaText)`
  color: ${({ theme }) => theme.colors.text.subtle35};
  margin-bottom: 2px;
`;

export const RoundIconButton = styled.TouchableOpacity`
  width: 36px;
  height: 36px;
  background-color: ${({ theme }) => theme.colors.brand.subtleWhite};
  border-radius: 12px;
  justify-content: center;
  align-items: center;
`;

export const StatusBanner = styled.TouchableOpacity`
  flex-direction: row;
  align-items: center;
  background-color: ${({ theme }) => theme.colors.amber.subtleBg};
  border-width: 1px;
  border-color: ${({ theme }) => theme.colors.amber.subtleBorder};
  border-radius: 12px;
  padding: 10px 12px;
  margin-top: 10px;
`;

export const BannerText = styled(MetaText)`
  color: ${({ theme }) => theme.colors.amber[500]};
  font-weight: 500;
  flex: 1;
  margin: 0 9px;
`;

export const Badge = styled.View<{ bgColor: string }>`
  background-color: ${props => props.bgColor};
  border-radius: 99px;
  padding: 3px 9px;
`;

/** Badge específico para CTA de alerta com alinhamento interno */
export const AlertCtaBadge = styled(Badge).attrs(({ theme }) => ({
  bgColor: theme.colors.brand.logoBorder,
}))`
  flex-direction: row;
  align-items: center;
`;

/** Texto interno do badge de alerta */
export const AlertBadgeText = styled(MetaText)`
  color: ${({ theme }) => theme.colors.white};
  margin-right: 4px;
`;
