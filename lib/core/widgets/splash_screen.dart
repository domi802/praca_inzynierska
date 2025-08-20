import 'package:flutter/material.dart';

/// Ekran splash wyświetlany podczas inicjalizacji aplikacji
class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo aplikacji
            Icon(
              Icons.subscriptions,
              size: 80,
              color: Colors.white,
            ),
            SizedBox(height: 24),
            
            // Nazwa aplikacji
            Text(
              'Menedżer Subskrypcji',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 48),
            
            // Wskaźnik ładowania
            CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 3,
            ),
            SizedBox(height: 16),
            
            Text(
              'Inicjalizowanie...',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
