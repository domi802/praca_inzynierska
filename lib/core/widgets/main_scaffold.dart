import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'animated_bottom_navigation_bar.dart';

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
    
    return AnimatedBottomNavigationBar(
      currentIndex: _getSelectedIndex(currentPath),
      onTap: (index) => _onItemTapped(context, index),
    );
  }

  int _getSelectedIndex(String currentPath) {
    if (currentPath == '/') {
      return 0; // Główna
    } else if (currentPath.startsWith('/subscription/add')) {
      return 2; // ADD - aby nie podświetlać innych przycisków
    } else if (currentPath.startsWith('/subscription')) {
      return 0; // Inne strony subskrypcji -> Główna
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
    final String currentPath = GoRouterState.of(context).uri.path;
    
    switch (index) {
      case 0:
        context.go('/?from=$currentPath');
        break;
      case 1:
        context.go('/calendar?from=$currentPath');
        break;
      case 2:
        context.go('/subscription/add');
        break;
      case 3:
        context.go('/stats?from=$currentPath');
        break;
      case 4:
        context.go('/settings?from=$currentPath');
        break;
    }
  }
}
