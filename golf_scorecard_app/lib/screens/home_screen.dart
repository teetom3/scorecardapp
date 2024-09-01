import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'scorecard_list_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0; // Index de la vue actuelle affichée
  final List<Widget> _screens = [
    DashboardScreen(),
    ScoreCardListScreen()
  ]; // Liste des écrans

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[
          _currentIndex], // Affiche l'écran correspondant à l'index actuel
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Met à jour l'index actuel
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Cartes de Score',
          ),
        ],
      ),
    );
  }
}
