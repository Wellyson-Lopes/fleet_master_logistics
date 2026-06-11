import React from 'react';
import { View, Text, StyleSheet, TouchableOpacity } from 'react-native';
import { useAuth } from '../context/AuthContext';

export const HomeScreen = () => {
  const { user, signOut } = useAuth();

  return (
    <View style={styles.container}>
      <Text style={styles.welcome}>Bem-vindo,</Text>
      <Text style={styles.name}>{user?.name || user?.email}</Text>
      
      <View style={styles.card}>
        <Text style={styles.cardTitle}>Status do Motorista</Text>
        <Text style={styles.cardStatus}>🟢 Online e Disponível</Text>
      </View>

      <TouchableOpacity style={styles.logoutButton} onPress={signOut}>
        <Text style={styles.logoutText}>Sair do Aplicativo</Text>
      </TouchableOpacity>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    padding: 30,
    justifyContent: 'center',
    backgroundColor: '#FFF',
  },
  welcome: {
    fontSize: 20,
    color: '#666',
  },
  name: {
    fontSize: 28,
    fontWeight: 'bold',
    color: '#1A1A1A',
    marginBottom: 30,
  },
  card: {
    backgroundColor: '#F8F9FA',
    padding: 20,
    borderRadius: 15,
    borderWidth: 1,
    borderColor: '#EEE',
    marginBottom: 40,
  },
  cardTitle: {
    fontSize: 16,
    color: '#666',
    marginBottom: 5,
  },
  cardStatus: {
    fontSize: 18,
    fontWeight: 'bold',
    color: '#28A745',
  },
  logoutButton: {
    padding: 15,
    alignItems: 'center',
  },
  logoutText: {
    color: '#DC3545',
    fontSize: 16,
    fontWeight: 'bold',
  },
});
