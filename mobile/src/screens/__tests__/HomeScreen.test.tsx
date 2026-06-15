import React from 'react';
import renderer from 'react-test-renderer';
import { HomeScreen } from '../HomeScreen';
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

describe('HomeScreen', () => {
  it('deve renderizar corretamente com nome do motorista', () => {
    (useAuth as jest.Mock).mockReturnValue({
      user: { name: 'João Silva', email: 'joao@fleetmaster.com' },
      signOut: jest.fn(),
    });

    const tree = renderer.create(
      <AllTheProviders>
        <HomeScreen />
      </AllTheProviders>
    ).toJSON();
    
    expect(tree).toMatchSnapshot();
  });

  it('deve renderizar corretamente com email quando nome for nulo', () => {
    (useAuth as jest.Mock).mockReturnValue({
      user: { name: null, email: 'motorista@fleetmaster.com' },
      signOut: jest.fn(),
    });

    const tree = renderer.create(
      <AllTheProviders>
        <HomeScreen />
      </AllTheProviders>
    ).toJSON();
    
    expect(tree).toMatchSnapshot();
  });
});
