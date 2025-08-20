import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Główny scaffold aplikacji z dolną nawigacją
class MainScaffold extends StatelessWidget {
  final Widget child;

  const MainScaffold({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    final String currentPath = GoRouterState.of(context).uri.path;
    
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _getSelectedIndex(currentPath),
      onTap: (index) => _onItemTapped(context, index),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Główna',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_month),
          label: 'Kalendarz',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_circle, size: 32),
          label: 'Dodaj',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.analytics),
          label: 'Statystyki',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profil',
        ),
      ],
    );
  }

  int _getSelectedIndex(String currentPath) {
    if (currentPath == '/' || currentPath.startsWith('/subscription')) {
      return 0; // Główna
    } else if (currentPath.startsWith('/calendar')) {
      return 1; // Kalendarz
    } else if (currentPath.startsWith('/stats')) {
      return 3; // Statystyki (przesunięte o jeden)
    } else if (currentPath.startsWith('/settings')) {
      return 4; // Profil (przesunięte o jeden)
    }
    return 0; // Domyślnie główna
  }

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/calendar');
        break;
      case 2:
        context.go('/subscription/add');
        break;
      case 3:
        context.go('/stats');
        break;
      case 4:
        context.go('/settings');
        break;
    }
  }
}
