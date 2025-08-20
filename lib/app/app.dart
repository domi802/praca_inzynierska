import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'router.dart';
import 'theme.dart';
import '../features/auth/logic/auth_bloc.dart';
import '../core/widgets/splash_screen.dart';

/// Główny widget aplikacji
class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        print('AuthState: $authState');
        print('Is authenticated: ${authState is AuthAuthenticated}');
        
        // Wyświetl splash screen podczas inicjalizacji
        if (authState is AuthInitial) {
          return MaterialApp(
            title: 'Menedżer Subskrypcji',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: ThemeMode.system,
            locale: const Locale('pl', 'PL'),
            supportedLocales: const [
              Locale('pl', 'PL'),
              Locale('en', 'US'),
            ],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: const SplashScreen(),
          );
        }
        
        // Konfiguracja routera na podstawie stanu uwierzytelnienia
        final router = AppRouter.createRouter(
          isAuthenticated: authState is AuthAuthenticated,
        );

        return MaterialApp.router(
          title: 'Menedżer Subskrypcji',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.system,
          routerConfig: router,
          
          // Lokalizacja
          locale: const Locale('pl', 'PL'),
          supportedLocales: const [
            Locale('pl', 'PL'),
            Locale('en', 'US'),
          ],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          
          // Builder do obsługi błędów routingu
          builder: (context, child) {
            return child ?? const Scaffold(
              body: Center(
                child: Text('Błąd ładowania aplikacji'),
              ),
            );
          },
        );
      },
    );
  }
}
