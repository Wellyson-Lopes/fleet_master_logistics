import styled from 'styled-components/native';
import { MetaText, ScreenTitle } from './Typography';

/**
 * Componentes de Layout e Estrutura seguindo o Design System do FleetMaster.
 * Centralizados para garantir consistência em todas as telas.
 */

/** Container principal da tela com fundo Navy */
export const ScreenContainer = styled.View`
  flex: 1;
  background-color: ${({ theme }) => theme.colors.navy[900]};
`;

/** Container principal para telas claras (Light Mode / Content Screens) */
export const ContentContainer = styled.View`
  flex: 1;
  background-color: ${({ theme }) => theme.colors.slate[50]};
`;

/** Brilho de fundo circular usado em telas Navy (ex: Login) */
export const BackgroundGlow = styled.View`
  position: absolute;
  top: -80px;
  right: -80px;
  width: 260px;
  height: 260px;
  background-color: ${({ theme }) => theme.colors.brand.glow};
  border-radius: 130px;
`;

/** Conteúdo com rolagem e preenchimento padrão */
export const ScrollContent = styled.ScrollView.attrs({
  contentContainerStyle: {
    flexGrow: 1,
    paddingHorizontal: 20,
    paddingTop: 60,
    paddingBottom: 40,
  },
})``;

/** Conteúdo com rolagem específico para a Home (menos padding no topo) */
export const HomeScrollContent = styled.ScrollView.attrs({
  contentContainerStyle: {
    paddingBottom: 30,
  },
})`
  flex: 1;
`;

/** Preenchimento interno padrão para seções de conteúdo */
export const ContentPadding = styled.View`
  padding: 14px 14px 0;
`;

/** Container para centralizar logos */
export const LogoContainer = styled.View`
  align-items: center;
  margin-bottom: 40px;
`;

/** Título da marca na tela de login */
export const LoginBrandTitle = styled(ScreenTitle)`
  font-size: 26px;
  font-weight: 800;
  letter-spacing: -1px;
  margin-top: 12px;
`;

/** Subtítulo da marca na tela de login */
export const LoginBrandSub = styled(MetaText)`
  margin-top: 4px;
  color: ${({ theme }) => theme.colors.text.subtle30};
`;

/** Grupo de espaçamento para inputs e formulários */
export const InputGroup = styled.View`
  margin-bottom: 20px;
`;

/** Espaçamento superior para botões em formulários */
export const ButtonSpacer = styled.View`
  margin-top: 8px;
`;

/** Rodapé de telas (ex: Copyright, Links secundários) */
export const ScreenFooter = styled.View`
  margin-top: 24px;
  align-items: center;
`;

/** Texto de copyright no rodapé */
export const CopyrightText = styled(MetaText)`
  color: ${({ theme }) => theme.colors.text.subtle20};
  font-size: 10px;
`;

/** Container para o botão de logout ou ações de final de página */
export const LogoutSection = styled.View`
  padding: 16px;
  margin-top: 10px;
`;

/** Espaçamento entre seções horizontais */
export const HorizontalGap4 = styled.View`
  width: 4px;
`;
