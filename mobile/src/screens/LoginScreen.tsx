import React, { useState } from 'react';
import { StatusBar, KeyboardAvoidingView, Platform, Alert, ActivityIndicator } from 'react-native';
import styled, { useTheme } from 'styled-components/native';
import { ScreenTitle, MetaText } from '../components/styled/Typography';
import { PrimaryButton, ButtonText } from '../components/styled/Button';
import { StyledInput, InputLabel } from '../components/styled/Input';
import { DarkCard } from '../components/styled/Card';
import { useAuth } from '../context/AuthContext';

// Importando a logo como componente SVG
import LogoSvg from '../../assets/images/logo.svg';

const Container = styled.View`
  flex: 1;
  background-color: ${({ theme }) => theme.colors.navy[900]};
`;

const BackgroundGlow = styled.View`
  position: absolute;
  top: -80px;
  right: -80px;
  width: 260px;
  height: 260px;
  background-color: ${({ theme }) => theme.colors.brand.glow};
  border-radius: 130px;
`;

const ScrollContent = styled.ScrollView.attrs({
  contentContainerStyle: {
    flexGrow: 1,
    paddingHorizontal: 20,
    paddingTop: 60,
    paddingBottom: 40,
    justifyContent: 'center',
  },
})``;

const LogoContainer = styled.View`
  align-items: center;
  margin-bottom: 40px;
`;

const BrandName = styled(ScreenTitle)`
  font-size: 26px;
  font-weight: 800;
  letter-spacing: -1px;
  margin-top: 12px;
`;

const AppSubTitle = styled(MetaText)`
  margin-top: 4px;
  color: ${({ theme }) => theme.colors.text.subtle30};
`;

const LoginCard = styled(DarkCard)`
  padding: 24px;
`;

const LoginTitle = styled(ScreenTitle)`
  font-size: 18px;
  margin-bottom: 4px;
`;

const LoginSub = styled(MetaText)`
  font-size: 12px;
  color: ${({ theme }) => theme.colors.text.subtle35};
  margin-bottom: 24px;
`;

const InputGroup = styled.View`
  margin-bottom: 20px;
`;

const SubmitButton = styled(PrimaryButton)`
  margin-top: 8px;
`;

const LoginFooter = styled.View`
  margin-top: 24px;
  align-items: center;
`;

const CopyrightText = styled(MetaText)`
  color: ${({ theme }) => theme.colors.text.subtle20};
  font-size: 10px;
`;

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
    <Container>
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
            <BrandName>FleetMaster</BrandName>
            <AppSubTitle>Módulo do Motorista v1.0</AppSubTitle>
          </LogoContainer>

          <LoginCard>
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
              />
            </InputGroup>

            <SubmitButton 
              fullWidth 
              onPress={handleLogin}
              disabled={loading}
            >
              {loading ? (
                <ActivityIndicator color={theme.colors.white} />
              ) : (
                <ButtonText>Entrar na plataforma →</ButtonText>
              )}
            </SubmitButton>
          </LoginCard>

          <LoginFooter>
            <CopyrightText>
              © 2026 FleetMaster Logistics · Todos os direitos reservados
            </CopyrightText>
          </LoginFooter>
        </ScrollContent>
      </KeyboardAvoidingView>
    </Container>
  );
};

export default LoginScreen;
