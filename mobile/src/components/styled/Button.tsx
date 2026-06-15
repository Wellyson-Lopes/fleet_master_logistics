import styled from 'styled-components/native';

/**
 * Componentes de Botão seguindo o Design System do FleetMaster.
 * Todos os botões suportam a propriedade `fullWidth` para ocupar 100% da largura.
 */

interface ButtonProps {
  /** Se verdadeiro, o botão ocupará 100% da largura disponível */
  fullWidth?: boolean;
}

const BaseButton = styled.TouchableOpacity<ButtonProps>`
  border-radius: 12px;
  padding: 12px 18px;
  align-items: center;
  justify-content: center;
  width: ${(props: ButtonProps) => props.fullWidth ? '100%' : 'auto'};
`;

/** Estilo padrão para o texto dentro dos botões */
export const ButtonText = styled.Text`
  font-size: 13px;
  font-weight: 700;
  color: ${({ theme }) => theme.colors.white};
`;

/** Botão Primário (Azul): Usado para a ação principal da tela */
export const PrimaryButton = styled(BaseButton)`
  background-color: ${({ theme }) => theme.colors.blue[500]};
  elevation: 4;
  shadow-color: ${({ theme }) => theme.colors.blue[500]};
  shadow-offset: 0px 4px;
  shadow-opacity: 0.35;
  shadow-radius: 14px;
`;

/** Botão Sucesso (Teal): Usado para confirmações positivas ou finalizações */
export const TealButton = styled(BaseButton)`
  background-color: ${({ theme }) => theme.colors.teal[500]};
  elevation: 4;
  shadow-color: ${({ theme }) => theme.colors.teal[500]};
  shadow-offset: 0px 4px;
  shadow-opacity: 0.3;
  shadow-radius: 14px;
`;

/** Botão Alerta/Erro (Vermelho): Usado para exclusões ou ações críticas */
export const DangerButton = styled(BaseButton)`
  background-color: ${({ theme }) => theme.colors.red[500]};
  elevation: 4;
  shadow-color: ${({ theme }) => theme.colors.red[500]};
  shadow-offset: 0px 4px;
  shadow-opacity: 0.3;
  shadow-radius: 14px;
`;

/** Botão Fantasma (Cinza claro): Usado para ações secundárias ou cancelamentos */
export const GhostButton = styled(BaseButton)`
  background-color: ${({ theme }) => theme.colors.slate[100]};
`;

/** Texto específico para o Botão Fantasma */
export const GhostButtonText = styled(ButtonText)`
  color: ${({ theme }) => theme.colors.slate[500]};
`;

/** Botão Fantasma Dark: Variante para uso sobre fundos Navy/Escuros */
export const DarkGhostButton = styled(BaseButton)`
  background-color: ${({ theme }) => theme.colors.text.subtle20};
  border-width: 1px;
  border-color: ${({ theme }) => theme.colors.text.subtle25};
`;

/** Botão Outline: Apenas bordas, usado para ações opcionais */
export const OutlineButton = styled(BaseButton)`
  background-color: transparent;
  border-width: 1.5px;
  border-color: ${({ theme }) => theme.colors.text.subtle20};
`;

/** Texto específico para o Botão Outline */
export const OutlineButtonText = styled(ButtonText)`
  color: ${({ theme }) => theme.colors.text.body};
`;
