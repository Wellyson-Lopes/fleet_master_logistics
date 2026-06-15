import React, { useState } from 'react';
import { StatusBar, KeyboardAvoidingView, Platform, Alert, ActivityIndicator } from 'react-native';
import { useTheme } from 'styled-components/native';
import { PrimaryButton, ButtonText } from '../components/styled/Button';
import { StyledInput, InputLabel } from '../components/styled/Input';
import { 
  ScreenContainer, 
  BackgroundGlow, 
  ScrollContent, 
  LogoContainer, 
  LoginBrandTitle,
  LoginBrandSub,
  InputGroup, 
  ButtonSpacer,
  ScreenFooter,
  CopyrightText
} from '../components/styled/Layout';
import { LoginFormCard, LoginTitle, LoginSub } from '../components/styled/Card';
import { useAuth } from '../context/AuthContext';

// Importando a logo como componente SVG
import LogoSvg from '../../assets/images/logo.svg';

export const LoginScreen = () => {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [isEmailFocused, setIsEmailFocused] = useState(false);
  const [isPassFocused, setIsPassFocused] = useState(false);
  const [loading, setLoading] = useState(false);

  const { signIn } = useAuth();
  const theme = useTheme();

  const handleLogin = async () => {
    if (!email || !password) {
      Alert.alert('Erro', 'Por favor, preencha todos os campos.');
      return;
    }

    setLoading(true);
    try {
      await signIn(email, password);
    } catch (error: any) {
      const message = error.response?.data?.status?.message || 'Falha na conexão ou credenciais inválidas.';
      Alert.alert('Erro no Login', message);
    } finally {
      setLoading(false);
    }
  };

  return (
    <ScreenContainer>
      <StatusBar 
        barStyle="light-content" 
        backgroundColor={theme.colors.navy[900]} 
      />
      <BackgroundGlow />
      
      <KeyboardAvoidingView 
        behavior={Platform.OS === 'ios' ? 'padding' : 'height'}
        style={{ flex: 1 }}
      >
        <ScrollContent showsVerticalScrollIndicator={false}>
          <LogoContainer>
            <LogoSvg width={100} height={100} />
            <LoginBrandTitle>FleetMaster</LoginBrandTitle>
            <LoginBrandSub>Módulo do Motorista v1.0</LoginBrandSub>
          </LogoContainer>

          <LoginFormCard>
            <LoginTitle>Acesse sua conta</LoginTitle>
            <LoginSub>Informe suas credenciais para continuar</LoginSub>

            <InputGroup>
              <InputLabel>E-mail ou Usuário</InputLabel>
              <StyledInput
                placeholder="ex: motorista@fleetmaster.com"
                value={email}
                onChangeText={setEmail}
                onFocus={() => setIsEmailFocused(true)}
                onBlur={() => setIsEmailFocused(false)}
                isFocused={isEmailFocused}
                autoCapitalize="none"
                keyboardType="email-address"
                editable={!loading}
                accessibilityLabel="Campo de e-mail ou usuário"
              />
            </InputGroup>

            <InputGroup>
              <InputLabel>Senha</InputLabel>
              <StyledInput
                placeholder="••••••••"
                value={password}
                onChangeText={setPassword}
                onFocus={() => setIsPassFocused(true)}
                onBlur={() => setIsPassFocused(false)}
                isFocused={isPassFocused}
                secureTextEntry
                editable={!loading}
                accessibilityLabel="Campo de senha"
              />
            </InputGroup>

            <ButtonSpacer>
              <PrimaryButton 
                fullWidth 
                onPress={handleLogin}
                disabled={loading}
                accessibilityLabel="Botão para entrar na plataforma"
                accessibilityRole="button"
              >
                {loading ? (
                  <ActivityIndicator color={theme.colors.white} />
                ) : (
                  <ButtonText>Entrar na plataforma →</ButtonText>
                )}
              </PrimaryButton>
            </ButtonSpacer>
          </LoginFormCard>

          <ScreenFooter>
            <CopyrightText>
              © 2026 FleetMaster Logistics · Todos os direitos reservados
            </CopyrightText>
          </ScreenFooter>
        </ScrollContent>
      </KeyboardAvoidingView>
    </ScreenContainer>
  );
};

export default LoginScreen;
