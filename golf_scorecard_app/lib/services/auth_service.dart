import 'package:flutter/material.dart';
import 'database_service.dart';

class AuthService with ChangeNotifier {
  bool _isAuthenticated = false;
  String? _currentUser;

  bool get isAuthenticated => _isAuthenticated;
  String? get currentUser => _currentUser;

  Future<void> register(String username, String password) async {
    try {
      await DatabaseService().registerUser(username, password);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> login(String username, String password) async {
    final success = await DatabaseService().loginUser(username, password);
    if (success) {
      _isAuthenticated = true; // L'utilisateur est authentifié
      _currentUser = username; // Stocke le nom d'utilisateur
      notifyListeners(); // Notifie les écouteurs que l'état a changé
    } else {
      throw Exception('Identifiants incorrects.');
    }
  }

  void logout() {
    _isAuthenticated = false; // Réinitialise l'état d'authentification
    _currentUser = null;
    notifyListeners(); // Notifie les écouteurs que l'état a changé
  }
}
