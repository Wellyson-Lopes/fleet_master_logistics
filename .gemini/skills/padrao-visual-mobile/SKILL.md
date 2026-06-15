---
name: padrao-visual-mobile
description: Garante que o desenvolvimento do frontend mobile siga o "Padrão de Ouro" do FleetMaster (React Native + Styled-components + ThemeProvider). Use para implementar telas/funções sob demanda, eliminando valores hardcoded e estilos inline, focando na centralização via design tokens.
---

# 📱 Padrão Visual Mobile FleetMaster

Esta skill orienta a implementação da interface mobile, focando em escalabilidade, tipagem forte e centralização de estilos.

## 🛠️ Stack Tecnológica & Padrões
- **Base:** React Native (TypeScript).
- **Estilização:** Styled-components com **ThemeProvider**.
- **Module Augmentation:** O tema é injetado globalmente. Nunca anote `{ theme: ThemeType }` manualmente nos componentes estilizados; use diretamente `({ theme }) => theme...`.
- **Referência:** `mobile/mockup/fleetmaster_mobile_mockup.html`.

## 💎 Regras de Ouro (Zero Hardcoded)

1. **PROIBIDO Cores Mágicas:** Nunca use hexadecimais ou RGBA diretamente nos arquivos `.tsx` ou `.styles.ts`. Utilize sempre os tokens em `theme/colors.ts`.
2. **PROIBIDO Estilos Inline:** Não utilize a prop `style={{...}}` para margens, cores ou preenchimentos. Crie um componente estilizado semântico (ex: `LoginCard`, `Spacing`).
3. **Attrs para Props Nativas:** Utilize `.attrs()` para configurar propriedades nativas que dependem do tema, como `placeholderTextColor` em Inputs ou `color` em ActivityIndicators (via hook).
4. **Hook useTheme:** Em componentes funcionais, utilize `const theme = useTheme();` para acessar o tema em componentes que não aceitam Styled-components (ex: StatusBar, ActivityIndicator).

## 🔄 Fluxo de Desenvolvimento (Estilos Primeiro)

1. **Extração:** Mapeie novos tokens necessários do mockup para o `theme/colors.ts`.
2. **Componentização:** Crie ou ajuste os componentes em `mobile/src/components/styled/`.
3. **Implementação:** Monte a View utilizando apenas componentes estilizados.

## 🚀 Exemplo Padrão de Ouro

```typescript
// ✅ CORRETO
const Container = styled.View`
  background-color: ${({ theme }) => theme.colors.navy[900]};
`;

// ❌ INCORRETO
const Container = styled.View`
  background-color: #0B1628;
`;
```

## ⚠️ Ordem de Execução
Estilos (Centralizados no Tema) -> Componentes Atômicos -> Views Declarativas.
