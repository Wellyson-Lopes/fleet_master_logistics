import React from 'react';
import renderer, { act } from 'react-test-renderer';
import { HomeScreen } from '../HomeScreen';
import { ThemeProvider } from 'styled-components/native';
import { theme } from '../../theme/colors';
import { useAuth } from '../../context/AuthContext';

// Mock do useAuth
jest.mock('../../context/AuthContext', () => ({
  useAuth: jest.fn(),
}));

// Mock do useHomeData
jest.mock('../../hooks/useHomeData', () => ({
  useHomeData: jest.fn(() => ({
    userName: 'Motorista Teste',
    activeTrip: null,
    alerts: [],
    recentTrips: [],
    kpis: [
      { id: 'trips', label: 'Viagens Hoje', value: '0', delta: '0%' },
      { id: 'deliveries', label: 'Entregas', value: '0', delta: '0' },
      { id: 'incidents', label: 'Ocorrências', value: '0', delta: 'em dia' },
      { id: 'efficiency', label: 'Eficiência', value: '100%', delta: '100%' },
    ],
  })),
}));

// Mock da API
jest.mock('../../api/client', () => ({
  __esModule: true,
  default: {
    get: jest.fn().mockResolvedValue({ data: {} }),
    post: jest.fn().mockResolvedValue({ data: {} }),
    interceptors: {
      request: { use: jest.fn() },
    },
  },
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

// TODO: Snapshot renderiza null devido a incompatibilidade react-test-renderer 19 + RN 0.81.
// Migrar para @testing-library/react-native compatível com React 19.
// Acompanhar: https://github.com/facebook/react/issues e https://github.com/expo/jest-expo/issues
describe('HomeScreen', () => {
  it('deve renderizar corretamente com nome do motorista', () => {
    (useAuth as jest.Mock).mockReturnValue({
      user: { name: 'João Silva', email: 'joao@fleetmaster.com' },
      signOut: jest.fn(),
    });

    let tree: any;
    act(() => {
      tree = renderer.create(
        <AllTheProviders>
          <HomeScreen />
        </AllTheProviders>
      ).toJSON();
    });
    
    expect(tree).toMatchSnapshot();
  });

  it('deve renderizar corretamente com email quando nome for nulo', () => {
    (useAuth as jest.Mock).mockReturnValue({
      user: { name: null, email: 'motorista@fleetmaster.com' },
      signOut: jest.fn(),
    });

    let tree: any;
    act(() => {
      tree = renderer.create(
        <AllTheProviders>
          <HomeScreen />
        </AllTheProviders>
      ).toJSON();
    });
    
    expect(tree).toMatchSnapshot();
  });
});
