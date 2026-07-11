import React from 'react';
import renderer from 'react-test-renderer';
import { ThemeProvider } from 'styled-components/native';
import { theme } from '../../../theme/colors';
import { PrimaryButton } from '../Button';
import { ScreenTitle } from '../Typography';
import { StyledCard } from '../Card';

const AllTheProviders = ({ children }: { children: React.ReactNode }) => {
  return (
    <ThemeProvider theme={theme}>
      {children}
    </ThemeProvider>
  );
};

// TODO: Atualizar react-test-renderer ou migrar para @testing-library/react-native
// compatível com React 19. Atualmente toJSON() retorna null para todos os componentes
// devido a incompatibilidade entre react-test-renderer 19 e React Native 0.81.
// Acompanhar: https://github.com/facebook/react/issues e https://github.com/expo/jest-expo/issues
describe('Componentes do Design System', () => {
  it('deve renderizar ScreenTitle corretamente', () => {
    const tree = renderer.create(
      <AllTheProviders>
        <ScreenTitle>Título Teste</ScreenTitle>
      </AllTheProviders>
    ).toJSON();
    expect(tree).toMatchSnapshot();
  });

  it('deve renderizar PrimaryButton corretamente', () => {
    const tree = renderer.create(
      <AllTheProviders>
        <PrimaryButton>
          <ScreenTitle>Botão</ScreenTitle>
        </PrimaryButton>
      </AllTheProviders>
    ).toJSON();
    expect(tree).toMatchSnapshot();
  });

  it('deve renderizar StyledCard corretamente', () => {
    const tree = renderer.create(
      <AllTheProviders>
        <StyledCard />
      </AllTheProviders>
    ).toJSON();
    expect(tree).toMatchSnapshot();
  });
});
