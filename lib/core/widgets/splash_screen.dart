import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';

/// Ekran splash wyświetlany podczas inicjalizacji aplikacji
class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
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
              localizations.appTitle,
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
              localizations.loadingDefault,
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
