---
name: padrao-visual-mobile
description: Garante que o desenvolvimento do frontend mobile siga o "Padrão de Ouro" do FleetMaster (React Native + Styled-components + ThemeProvider). Use para implementar telas/funções sob demanda, eliminando valores hardcoded e estilos inline, focando na centralização via design tokens.
---

# 📱 Padrão Visual Mobile FleetMaster

Esta skill orienta a implementação da interface mobile, focando em escalabilidade, tipagem forte e centralização absoluta de estilos.

## 🛠️ Stack Tecnológica & Padrões
- **Base:** React Native (TypeScript).
- **Estilização:** Styled-components com **ThemeProvider**.
- **Module Augmentation:** O tema é injetado globalmente via `styled.d.ts`. **NUNCA** anote `{ theme: ThemeType }` manualmente nos componentes estilizados; use diretamente `({ theme }) => theme...`.
- **Referência Principal:** `mobile/mockup/fleetmaster_mobile_mockup.html`.

## 💎 Regras de Ouro (Zero Hardcoded)

1. **PROIBIDO Cores Mágicas:** Nunca use hexadecimais ou RGBA diretamente nos arquivos `.tsx`. Utilize sempre os tokens em `theme/colors.ts`.
2. **PROIBIDO Estilos Inline:** Jamais utilize a prop `style={{...}}`. Crie componentes estilizados semânticos em `components/styled/` para gerenciar margens, preenchimentos e layouts.
3. **Propriedades Nativas via .attrs():** Utilize `.attrs()` em componentes Styled para configurar propriedades nativas que dependem do tema (ex: `placeholderTextColor` em Inputs, `selectionColor`).
4. **Hook useTheme para Componentes Funcionais:** Utilize `const theme = useTheme();` para acessar tokens de cor em componentes que não aceitam estilização via Styled-components (ex: `ActivityIndicator`, `StatusBar`, `victory-native`).

## 🔄 Fluxo de Desenvolvimento (Estilos Primeiro)

1. **Extração:** Mapeie novos tokens necessários do mockup para o `theme/colors.ts`.
2. **Globalização:** Verifique se o componente já existe em `mobile/src/components/styled/`. Se não, crie-o lá para que seja acessível por todas as views.
3. **Implementação:** Monte a View utilizando apenas componentes estilizados globais.

## 🚀 Exemplo Padrão de Ouro

```typescript
// ✅ CORRETO (Global e Tipado Automaticamente)
// components/styled/Layout.tsx
export const ScreenContainer = styled.View`
  background-color: ${({ theme }) => theme.colors.navy[900]};
`;

// ✅ CORRETO (Uso de useTheme para props nativas)
const theme = useTheme();
<ActivityIndicator color={theme.colors.white} />

// ❌ INCORRETO (Hardcoded e Local)
const Container = styled.View`
  background-color: #0B1628;
`;
```

## ⚠️ Ordem de Execução
Estilos Globais (Tema) -> Componentes Atômicos Globais -> Views Declarativas (Zero CSS Local).
