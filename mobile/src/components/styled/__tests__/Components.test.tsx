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

describe('Snapshots dos Componentes do Design System', () => {
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
