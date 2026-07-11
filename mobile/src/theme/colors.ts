export const colors = {
  navy: {
    900: '#0B1628', // Headers, status bar
    800: '#132036', // Cards dark
    700: '#1C2E4A', // Inputs dark
  },
  blue: {
    500: '#1A6CF6', // Primary, CTAs
    400: '#3D85F7', // Hover
    50: '#EBF3FF',  // Chips background
  },
  brand: {
    glow: 'rgba(26, 108, 246, 0.2)',
    logoCard: 'rgba(26, 108, 246, 0.15)',
    logoBorder: 'rgba(26, 108, 246, 0.3)',
    subtleWhite: 'rgba(255, 255, 255, 0.09)', // Para botões sobre Navy
    white10: 'rgba(255, 255, 255, 0.1)',     // Para itens de estatística Hero
  },
  teal: {
    500: '#0BBFA3', // Success/Route
    50: '#E8FAF7',  // Chips background
    subtleBg: 'rgba(11, 191, 163, 0.15)',
    subtleBorder: 'rgba(11, 191, 163, 0.3)',
  },
  amber: {
    500: '#F59E0B', // Warning
    100: '#FEF3C7', // Chips background
    subtleBg: 'rgba(245, 158, 11, 0.12)',
    subtleBorder: 'rgba(245, 158, 11, 0.22)',
  },
  red: {
    500: '#EF4444', // Error/Occurrence
  },
  green: {
    500: '#10B981', // Completed
  },
  slate: {
    50: '#F8FAFC',  // Main background
    100: '#F1F5F9', // Control background
    200: '#E2E8F0', // Borders
    400: '#94A3B8', // Inactive icons
    500: '#64748B', // Meta-text
    900: '#0F172A', // Primary text light mode
  },
  text: {
    white: '#FFFFFF',
    white55: 'rgba(255, 255, 255, 0.55)',
    white50: 'rgba(255, 255, 255, 0.5)',
    subtle35: 'rgba(255, 255, 255, 0.35)',
    subtle30: 'rgba(255, 255, 255, 0.3)',
    subtle25: 'rgba(255, 255, 255, 0.25)',
    subtle20: 'rgba(255, 255, 255, 0.2)',
    body: 'rgba(255, 255, 255, 0.8)',
    footer: 'rgba(255, 255, 255, 0.3)',
  },
  white: '#FFFFFF',
  transparent: 'transparent',
};

export const gradients = {
  primary: ['#1A6CF6', '#0F4FC8'],
  dark: ['#0B1628', '#091322'],
  success: ['#1A6CF6', '#0BBFA3'],
  fuel: ['#0B1628', '#0D1F3C'],
} as const;

export const theme = {
  colors,
  gradients
};

export type ThemeType = typeof theme;
