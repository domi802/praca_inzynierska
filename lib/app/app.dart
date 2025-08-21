import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'router.dart';
import 'theme.dart';
import '../features/auth/logic/auth_bloc.dart';
import '../features/settings/logic/settings_cubit.dart';
import '../core/widgets/splash_screen.dart';
import '../l10n/app_localizations.dart';
import '../core/services/localization_service.dart';

/// Główny widget aplikacji
class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, settingsState) {
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
                themeMode: settingsState.themeMode,
                locale: settingsState.locale,
                supportedLocales: const [
                  Locale('pl', 'PL'),
                  Locale('en', 'US'),
                ],
                localizationsDelegates: const [
                  AppLocalizations.delegate,
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
              themeMode: settingsState.themeMode,
              routerConfig: router,
              
              // Lokalizacja
              locale: settingsState.locale,
              supportedLocales: const [
                Locale('pl', 'PL'),
                Locale('en', 'US'),
              ],
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              
              // Builder do obsługi błędów routingu
              builder: (context, child) {
                final localizations = AppLocalizations.of(context);
                // Inicjalizuj serwis lokalizacji
                if (localizations != null) {
                  LocalizationService.initialize(context);
                }
                return child ?? Scaffold(
                  body: Center(
                    child: Text(localizations?.errorLoadingApp ?? 'Error loading app'),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
