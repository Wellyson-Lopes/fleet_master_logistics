import styled from 'styled-components/native';

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

/** Cabeçalho interno do card com layout horizontal (Flex-Row) */
export const CardHeader = styled.View`
  flex-direction: row;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 12px;
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
