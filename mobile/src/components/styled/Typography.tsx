import styled from 'styled-components/native';

/**
 * Componentes de Tipografia seguindo o Design System do FleetMaster.
 * Todos utilizam cores baseadas no tema global.
 */

/** Valor em destaque (ex: R$, Km, Percentuais de KPI) */
export const DisplayValue = styled.Text`
  font-size: 28px;
  font-weight: 800;
  color: ${({ theme }) => theme.colors.white};
  letter-spacing: -1.12px;
`;

/** Títulos de telas principais */
export const ScreenTitle = styled.Text`
  font-size: 17px;
  font-weight: 700;
  color: ${({ theme }) => theme.colors.white};
  letter-spacing: -0.34px;
`;

/** Títulos dentro de cards ou seções menores */
export const CardTitle = styled.Text`
  font-size: 14px;
  font-weight: 700;
  color: ${({ theme }) => theme.colors.white};
  letter-spacing: -0.21px;
`;

/** Texto de corpo de leitura geral */
export const BodyText = styled.Text`
  font-size: 13px;
  font-weight: 600;
  color: ${({ theme }) => theme.colors.text.body};
`;

/** Texto secundário, descrições ou legendas */
export const MetaText = styled.Text`
  font-size: 11px;
  font-weight: 400;
  color: ${({ theme }) => theme.colors.slate[500]};
`;

/** Rótulo de seções em caixa alta (Uppercase) */
export const SectionLabel = styled.Text`
  font-size: 10px;
  font-weight: 700;
  color: ${({ theme }) => theme.colors.text.subtle30};
  text-transform: uppercase;
  letter-spacing: 1px;
`;

/** Rótulo interno para Badges ou Chips */
export const ChipLabel = styled.Text`
  font-size: 10px;
  font-weight: 700;
`;

/** Placa de veículo (Fonte mono recomendada) */
export const TechPlaca = styled.Text`
  font-family: 'System';
  font-size: 14px;
  font-weight: 700;
  color: ${({ theme }) => theme.colors.white};
  letter-spacing: 0.28px;
`;

/** Identificadores técnicos (IDs, Protocolos) */
export const TechID = styled.Text`
  font-family: 'System';
  font-size: 11px;
  font-weight: 400;
  color: ${({ theme }) => theme.colors.slate[400]};
`;

/** Valores de odômetro ou medições técnicas */
export const TechKM = styled.Text`
  font-family: 'System';
  font-size: 12px;
  font-weight: 500;
  color: ${({ theme }) => theme.colors.text.body};
`;
