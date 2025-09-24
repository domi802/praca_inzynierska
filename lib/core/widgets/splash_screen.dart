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
      body: Column(
        children: [
          const SizedBox(height: 100),
          // Logo aplikacji
          Center(
            child: ColorFiltered(
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
              child: Image.asset(
                'assets/images/nameLogo.png',
                height: 320,
                fit: BoxFit.contain,
              ),
            ),
          ),
          const Spacer(),
          
          // Loader
          Center(
            child: Column(
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
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
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}
