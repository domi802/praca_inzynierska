import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart';

import 'logger_service.dart';

/// Serwis do zarządzania powiadomieniami lokalnymi
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  static NotificationService get instance => _instance;
  
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications = 
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  /// Inicjalizuje serwis powiadomień
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Sprawdź uprawnienia
      await _requestPermissions();

      // Konfiguracja dla Android
      const AndroidInitializationSettings androidSettings = 
          AndroidInitializationSettings('@mipmap/ic_launcher');

      // Konfiguracja dla iOS
      const DarwinInitializationSettings iosSettings = 
          DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      // Konfiguracja ogólna
      const InitializationSettings settings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      // Inicjalizacja
      await _notifications.initialize(
        settings,
        onDidReceiveNotificationResponse: _onNotificationTapped,
      );

      _isInitialized = true;
      LoggerService.info('Serwis powiadomień zainicjalizowany pomyślnie');
    } catch (e, stackTrace) {
      LoggerService.error('Błąd inicjalizacji serwisu powiadomień', e, stackTrace);
      rethrow;
    }
  }

  /// Obsługa kliknięcia w powiadomienie
  void _onNotificationTapped(NotificationResponse response) {
    LoggerService.info('Kliknięto powiadomienie: ${response.payload}');
    // TODO: Implementuj nawigację do odpowiedniego ekranu
  }

  /// Żądanie uprawnień do powiadomień
  Future<void> _requestPermissions() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      await Permission.notification.request();
    }
  }

  /// Zaplanuj powiadomienie o płatności subskrypcji
  Future<void> scheduleSubscriptionReminder({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  }) async {
    if (!_isInitialized) {
      LoggerService.warning('Serwis powiadomień nie jest zainicjalizowany');
      return;
    }

    try {
      const AndroidNotificationDetails androidDetails = 
          AndroidNotificationDetails(
        'subscription_reminders',
        'Przypomnienia o subskrypcjach',
        channelDescription: 'Powiadomienia o zbliżających się płatnościach',
        importance: Importance.high,
        priority: Priority.high,
        showWhen: true,
      );

      const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const NotificationDetails details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _notifications.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(scheduledDate, tz.local),
        details,
        payload: payload,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation: 
            UILocalNotificationDateInterpretation.absoluteTime,
      );

      LoggerService.info('Zaplanowano powiadomienie: $title na $scheduledDate');
    } catch (e, stackTrace) {
      LoggerService.error('Błąd planowania powiadomienia', e, stackTrace);
    }
  }

  /// Anuluj powiadomienie
  Future<void> cancelNotification(int id) async {
    try {
      await _notifications.cancel(id);
      LoggerService.info('Anulowano powiadomienie o ID: $id');
    } catch (e, stackTrace) {
      LoggerService.error('Błąd anulowania powiadomienia', e, stackTrace);
    }
  }

  /// Anuluj wszystkie powiadomienia
  Future<void> cancelAllNotifications() async {
    try {
      await _notifications.cancelAll();
      LoggerService.info('Anulowano wszystkie powiadomienia');
    } catch (e, stackTrace) {
      LoggerService.error('Błąd anulowania wszystkich powiadomień', e, stackTrace);
    }
  }

  /// Sprawdź czy powiadomienia są włączone
  Future<bool> areNotificationsEnabled() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return await Permission.notification.isGranted;
    }
    return true; // Na iOS zakładamy że są włączone
  }
}
