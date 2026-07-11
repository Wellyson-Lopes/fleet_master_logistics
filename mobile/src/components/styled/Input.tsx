import styled from 'styled-components/native';

/**
 * Componentes de Input seguindo o Design System do FleetMaster.
 * Inclui estados de foco, erro e rótulos padronizados.
 */

interface InputProps {
  /** Se verdadeiro, aplica o estilo visual de foco (borda azul/fundo translúcido) */
  isFocused?: boolean;
  /** Se verdadeiro, aplica o estilo visual de erro (borda vermelha/fundo avermelhado) */
  hasError?: boolean;
}

/** Input de texto principal com suporte a estados dinâmicos */
export const StyledInput = styled.TextInput.attrs(({ theme }) => ({
  placeholderTextColor: theme.colors.text.subtle25,
}))<InputProps>`
  background-color: ${({ theme, hasError, isFocused }) => 
    hasError ? theme.colors.text.subtle20 : 
    isFocused ? theme.colors.brand.logoCard : 
    theme.colors.text.subtle25};
  border-width: 1.5px;
  border-color: ${({ theme, hasError, isFocused }) => 
    hasError ? theme.colors.red[500] : 
    isFocused ? theme.colors.blue[500] : 
    theme.colors.text.subtle25};
  border-radius: 12px;
  padding: 11px 14px;
  font-size: 12px;
  color: ${({ theme }) => theme.colors.white};
  overflow: hidden;
`;

/** Rótulo informativo posicionado acima do input (Caps/Uppercase) */
export const InputLabel = styled.Text`
  font-size: 11px;
  font-weight: 700;
  color: ${({ theme }) => theme.colors.text.subtle30};
  margin-bottom: 8px;
  text-transform: uppercase;
  letter-spacing: 0.5px;
`;

/** Texto de erro exibido abaixo do input em caso de validação negativa */
export const ErrorText = styled.Text`
  font-size: 10px;
  color: ${({ theme }) => theme.colors.red[500]};
  margin-top: 4px;
`;
