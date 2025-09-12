import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'app/app.dart';
import 'core/services/notification_service.dart';
import 'core/services/logger_service.dart';
import 'features/auth/logic/auth_bloc.dart';
import 'features/subscriptions/logic/subscriptions_bloc.dart';
import 'features/settings/logic/settings_cubit.dart';
import 'firebase_options.dart';

/// Główny punkt wejścia aplikacji
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // Inicjalizacja Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    LoggerService.info('Firebase zainicjalizowany pomyślnie');
    
    // Inicjalizacja strefy czasowej dla powiadomień
    tz.initializeTimeZones();
    
    // Inicjalizacja serwisu powiadomień
    await NotificationService.instance.initialize();
    
    runApp(const SubscriptionManagerApp());
  } catch (e, stackTrace) {
    LoggerService.error('Błąd podczas inicjalizacji aplikacji', e, stackTrace);
    
    // Uruchom aplikację w trybie offline/fallback
    runApp(MaterialApp(
      locale: const Locale('pl'),
      supportedLocales: const [
        Locale('pl'),
        Locale('en'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red),
              SizedBox(height: 16),
              Text(
                'Błąd inicjalizacji aplikacji',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('Sprawdź połączenie internetowe i spróbuj ponownie'),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => main(),
                child: Text('Spróbuj ponownie'),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}

/// Główny widget aplikacji z dostawcami BLoC
class SubscriptionManagerApp extends StatelessWidget {
  const SubscriptionManagerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SettingsCubit>(
          create: (context) => SettingsCubit()..loadSettings(),
        ),        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc()..add(AuthInitialized()),
        ),
        BlocProvider<SubscriptionsBloc>(
          create: (context) => SubscriptionsBloc(),
        ),
      ],
      child: const App(),
    );
  }
}
