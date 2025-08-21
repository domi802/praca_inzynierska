import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

import '../features/auth/presentation/login_screen.dart';
import '../features/auth/presentation/register_screen.dart';
import '../features/subscriptions/presentation/subscriptions_list_screen.dart';
import '../features/subscriptions/presentation/subscription_detail_screen.dart';
import '../features/subscriptions/presentation/add_edit_subscription_screen.dart';
import '../features/calendar/presentation/calendar_screen.dart';
import '../features/stats/presentation/stats_screen.dart';
import '../features/settings/presentation/settings_screen.dart';
import '../features/settings/presentation/edit_profile_screen.dart';
import '../features/settings/presentation/change_password_screen.dart';
import '../core/widgets/main_scaffold.dart';
import '../core/services/logger_service.dart';
import '../l10n/app_localizations.dart';

/// Klasa zarządzająca routingiem aplikacji
class AppRouter {
  // Nazwy tras
  static const String loginRoute = '/login';
  static const String registerRoute = '/register';
  static const String homeRoute = '/';
  static const String subscriptionsRoute = '/subscriptions';
  static const String subscriptionDetailRoute = '/subscription/:id';
  static const String addSubscriptionRoute = '/subscription/add';
  static const String editSubscriptionRoute = '/subscription/:id/edit';
  static const String calendarRoute = '/calendar';
  static const String statsRoute = '/stats';
  static const String settingsRoute = '/settings';
  static const String editProfileRoute = '/profile/edit';
  static const String changePasswordRoute = '/profile/change-password';

  /// Tworzy konfigurację routera
  static GoRouter createRouter({required bool isAuthenticated}) {
    return GoRouter(
      initialLocation: isAuthenticated ? homeRoute : loginRoute,
      redirect: (context, state) {
        final String location = state.uri.path;
        
        LoggerService.info('Router redirect: location=$location, isAuthenticated=$isAuthenticated');
        
        // Jeśli użytkownik nie jest zalogowany i próbuje dostać się do chronionych tras
        if (!isAuthenticated && _isProtectedRoute(location)) {
          LoggerService.info('Przekierowanie do logowania z $location');
          return loginRoute;
        }
        
        // Jeśli użytkownik jest zalogowany i próbuje dostać się do tras auth
        if (isAuthenticated && _isAuthRoute(location)) {
          LoggerService.info('Przekierowanie do głównej z $location');
          return homeRoute;
        }
        
        LoggerService.info('Brak przekierowania dla $location');
        return null; // Brak przekierowania
      },
      routes: [
        // Trasy uwierzytelnienia
        GoRoute(
          path: loginRoute,
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: registerRoute,
          builder: (context, state) => const RegisterScreen(),
        ),
        
        // Główna nawigacja z dolną belką
        ShellRoute(
          builder: (context, state, child) {
            return MainScaffold(child: child);
          },
          routes: [
            // Lista subskrypcji (ekran główny)
            GoRoute(
              path: homeRoute,
              builder: (context, state) => const SubscriptionsListScreen(),
            ),
            
            // Dodawanie nowej subskrypcji
            GoRoute(
              path: addSubscriptionRoute,
              builder: (context, state) => const AddEditSubscriptionScreen(),
            ),
            
            // Szczegóły subskrypcji
            GoRoute(
              path: subscriptionDetailRoute,
              builder: (context, state) {
                final String subscriptionId = state.pathParameters['id']!;
                return SubscriptionDetailScreen(subscriptionId: subscriptionId);
              },
            ),
            
            // Edycja subskrypcji
            GoRoute(
              path: editSubscriptionRoute,
              builder: (context, state) {
                final String subscriptionId = state.pathParameters['id']!;
                return AddEditSubscriptionScreen(
                  subscriptionId: subscriptionId,
                );
              },
            ),
            
            // Kalendarz
            GoRoute(
              path: calendarRoute,
              builder: (context, state) => const CalendarScreen(),
            ),
            
            // Statystyki
            GoRoute(
              path: statsRoute,
              builder: (context, state) => const StatsScreen(),
            ),
            
            // Ustawienia
            GoRoute(
              path: settingsRoute,
              builder: (context, state) => const SettingsScreen(),
            ),
          ],
        ),
        
        // Trasy profilu (poza MainScaffold)
        GoRoute(
          path: editProfileRoute,
          builder: (context, state) => const EditProfileScreen(),
        ),
        GoRoute(
          path: changePasswordRoute,
          builder: (context, state) => const ChangePasswordScreen(),
        ),
      ],
      
      // Obsługa błędów routingu
      errorBuilder: (context, state) {
        final localizations = AppLocalizations.of(context);
        return Scaffold(
          appBar: AppBar(title: Text(localizations?.errorPageTitle ?? 'Error')),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red,
                ),
                const SizedBox(height: 16),
                Text(
                  'Nie znaleziono strony',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  'Ścieżka: ${state.uri.path}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => context.go(homeRoute),
                  child: const Text('Wróć do głównej'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  
  /// Sprawdza czy trasa wymaga uwierzytelnienia
  static bool _isProtectedRoute(String location) {
    // Trasy uwierzytelnienia nie są chronione
    if (_isAuthRoute(location)) {
      return false;
    }
    
    const protectedRoutes = [
      homeRoute, // '/'
      subscriptionsRoute, // '/subscriptions'
      calendarRoute, // '/calendar'
      statsRoute, // '/stats'
      settingsRoute, // '/settings'
      editProfileRoute, // '/profile/edit'
      changePasswordRoute, // '/profile/change-password'
    ];
    
    final isProtected = protectedRoutes.any((route) => 
      location == route || // Dokładne dopasowanie
      (route != homeRoute && location.startsWith(route + '/')) // Podrute (ale nie dla '/')
    ) || location.contains('/subscription/');
    
    LoggerService.info('_isProtectedRoute: location=$location, isProtected=$isProtected');
    for (final route in protectedRoutes) {
      if (location == route || (route != homeRoute && location.startsWith(route + '/'))) {
        LoggerService.info('  - Matches protected route: $route');
      }
    }
    if (location.contains('/subscription/')) {
      LoggerService.info('  - Contains "/subscription/"');
    }
    
    return isProtected;
  }
  
  /// Sprawdza czy trasa jest trasą uwierzytelnienia
  static bool _isAuthRoute(String location) {
    return location == loginRoute || location == registerRoute;
  }
}
