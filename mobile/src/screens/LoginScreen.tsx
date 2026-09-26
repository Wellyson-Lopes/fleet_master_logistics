import React, { useState } from 'react';
import { StatusBar, KeyboardAvoidingView, Platform, Alert, ActivityIndicator, TouchableOpacity, Text } from 'react-native';
import { useTheme } from 'styled-components/native';
import { PrimaryButton, TealButton, GhostButton, GhostButtonText, ButtonText } from '../components/styled/Button';
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
import { authService } from '../services/authService';

import LogoSvg from '../../assets/images/logo.svg';

export const LoginScreen = () => {
  const [isCodeMode, setIsCodeMode] = useState(false);
  const [codeVerified, setCodeVerified] = useState(false);

  // Campos padrão
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [code, setCode] = useState('');
  const [passwordConfirmation, setPasswordConfirmation] = useState('');
  const [name, setName] = useState('');
  const [loading, setLoading] = useState(false);

  const { signIn, signInWithCode } = useAuth();
  const theme = useTheme();

  const handleLogin = async () => {
    if (!email || !password) {
      Alert.alert('Atenção', 'Por favor, preencha o e-mail e a senha.');
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

  const handleVerifyCode = async () => {
    if (!email || !code) {
      Alert.alert('Atenção', 'Informe seu e-mail e o código de 6 dígitos recebido.');
      return;
    }

    setLoading(true);
    try {
      const res = await authService.verifyInvitationCode(email, code);
      if (res.data?.name) setName(res.data.name);
      setCodeVerified(true);
      Alert.alert('Sucesso', 'Código validado! Agora defina sua nova senha.');
    } catch (error: any) {
      const message = error.response?.data?.status?.message || 'Código inválido ou expirado.';
      Alert.alert('Erro na Validação', message);
    } finally {
      setLoading(false);
    }
  };

  const handleSetPassword = async () => {
    if (!password || !passwordConfirmation) {
      Alert.alert('Atenção', 'Preencha a nova senha e a confirmação.');
      return;
    }

    if (password !== passwordConfirmation) {
      Alert.alert('Atenção', 'As senhas não coincidem.');
      return;
    }

    setLoading(true);
    try {
      await signInWithCode({
        email,
        code,
        password,
        password_confirmation: passwordConfirmation,
        name: name.trim() || undefined,
      });
      Alert.alert('Parabéns!', 'Sua conta foi ativada com sucesso.');
    } catch (error: any) {
      const message = error.response?.data?.status?.message || 'Não foi possível cadastrar a senha.';
      Alert.alert('Erro', message);
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
            <LoginBrandSub>Módulo do Motorista</LoginBrandSub>
          </LogoContainer>

          <LoginFormCard>
            {!isCodeMode ? (
              // Modo 1: Login Convencional (E-mail + Senha)
              <>
                <LoginTitle>Acesse sua conta</LoginTitle>
                <LoginSub>Informe suas credenciais para continuar</LoginSub>

                <InputGroup>
                  <InputLabel>E-mail ou Usuário</InputLabel>
                  <StyledInput
                    placeholder="ex: motorista@empresa.com"
                    value={email}
                    onChangeText={setEmail}
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

                <TouchableOpacity 
                  onPress={() => { setIsCodeMode(true); setCodeVerified(false); }}
                  style={{ marginTop: 20, alignItems: 'center' }}
                >
                  <Text style={{ color: theme.colors.blue[500], fontSize: 13, fontWeight: '600' }}>
                    Primeiro acesso com código de e-mail? Clique aqui
                  </Text>
                </TouchableOpacity>
              </>
            ) : !codeVerified ? (
              // Modo 2 - Etapa A: Validação do Código de 6 Dígitos
              <>
                <LoginTitle>Primeiro Acesso</LoginTitle>
                <LoginSub>Digite o código de 6 dígitos que você recebeu</LoginSub>

                <InputGroup>
                  <InputLabel>E-mail de Cadastro</InputLabel>
                  <StyledInput
                    placeholder="ex: motorista@empresa.com"
                    value={email}
                    onChangeText={setEmail}
                    autoCapitalize="none"
                    keyboardType="email-address"
                    editable={!loading}
                  />
                </InputGroup>

                <InputGroup>
                  <InputLabel>Código de Acesso (6 dígitos)</InputLabel>
                  <StyledInput
                    placeholder="123456"
                    value={code}
                    onChangeText={setCode}
                    keyboardType="number-pad"
                    maxLength={6}
                    editable={!loading}
                  />
                </InputGroup>

                <ButtonSpacer>
                  <PrimaryButton 
                    fullWidth 
                    onPress={handleVerifyCode}
                    disabled={loading}
                  >
                    {loading ? (
                      <ActivityIndicator color={theme.colors.white} />
                    ) : (
                      <ButtonText>Validar Código →</ButtonText>
                    )}
                  </PrimaryButton>
                </ButtonSpacer>

                <TouchableOpacity 
                  onPress={() => setIsCodeMode(false)}
                  style={{ marginTop: 20, alignItems: 'center' }}
                >
                  <Text style={{ color: theme.colors.slate[500], fontSize: 13 }}>
                    ← Voltar para login com senha
                  </Text>
                </TouchableOpacity>
              </>
            ) : (
              // Modo 2 - Etapa B: Definir Senha e Completar Cadastro
              <>
                <LoginTitle>Definir Nova Senha</LoginTitle>
                <LoginSub>Crie sua senha de acesso para os próximos logins</LoginSub>

                <InputGroup>
                  <InputLabel>Seu Nome Completo</InputLabel>
                  <StyledInput
                    placeholder="Nome e Sobrenome"
                    value={name}
                    onChangeText={setName}
                    editable={!loading}
                  />
                </InputGroup>

                <InputGroup>
                  <InputLabel>Criar Senha</InputLabel>
                  <StyledInput
                    placeholder="Mínimo 6 caracteres"
                    value={password}
                    onChangeText={setPassword}
                    secureTextEntry
                    editable={!loading}
                  />
                </InputGroup>

                <InputGroup>
                  <InputLabel>Confirmar Senha</InputLabel>
                  <StyledInput
                    placeholder="Repita a senha"
                    value={passwordConfirmation}
                    onChangeText={setPasswordConfirmation}
                    secureTextEntry
                    editable={!loading}
                  />
                </InputGroup>

                <ButtonSpacer>
                  <TealButton 
                    fullWidth 
                    onPress={handleSetPassword}
                    disabled={loading}
                  >
                    {loading ? (
                      <ActivityIndicator color={theme.colors.white} />
                    ) : (
                      <ButtonText>Salvar Senha e Entrar ✓</ButtonText>
                    )}
                  </TealButton>
                </ButtonSpacer>

                <TouchableOpacity 
                  onPress={() => { setIsCodeMode(false); setCodeVerified(false); }}
                  style={{ marginTop: 20, alignItems: 'center' }}
                >
                  <Text style={{ color: theme.colors.slate[500], fontSize: 13 }}>
                    Cancelar e voltar ao login
                  </Text>
                </TouchableOpacity>
              </>
            )}
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
