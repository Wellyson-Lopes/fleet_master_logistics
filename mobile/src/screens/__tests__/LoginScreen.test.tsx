import React from 'react';
import renderer, { act } from 'react-test-renderer';
import { LoginScreen } from '../LoginScreen';
import { ThemeProvider } from 'styled-components/native';
import { theme } from '../../theme/colors';
import { useAuth } from '../../context/AuthContext';

// Mock do useAuth
jest.mock('../../context/AuthContext', () => ({
  useAuth: jest.fn(),
}));


// Mock do expo-linear-gradient
jest.mock('expo-linear-gradient', () => ({
  LinearGradient: ({ children }: { children: React.ReactNode }) => children,
}));

// Mock do expo-status-bar
jest.mock('expo-status-bar', () => ({
  StatusBar: () => null,
}));

const AllTheProviders: React.FC<{ children: React.ReactNode }> = ({ children }) => (
  <ThemeProvider theme={theme}>
    {children}
  </ThemeProvider>
);

describe('LoginScreen', () => {
  beforeEach(() => {
    (useAuth as jest.Mock).mockReturnValue({
      signIn: jest.fn(),
      signInWithCode: jest.fn(),
    });
  });

  it('deve renderizar a tela de login padrão corretamente', () => {
    let tree: any;
    act(() => {
      tree = renderer.create(
        <AllTheProviders>
          <LoginScreen />
        </AllTheProviders>
      ).toJSON();
    });

    expect(tree).toMatchSnapshot();
  });
});
