import 'styled-components';
import 'styled-components/native';
import { ThemeType } from './src/theme/colors';

declare module 'styled-components' {
  export interface DefaultTheme extends ThemeType {}
}

declare module 'styled-components/native' {
  export interface DefaultTheme extends ThemeType {}
}
