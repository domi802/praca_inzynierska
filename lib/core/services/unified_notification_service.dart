import '../../features/subscriptions/data/subscription_model.dart';
import 'notification_service.dart';
import 'calendar_notification_service.dart';
import 'email_notification_service.dart';
import 'widget_notification_service.dart';
import 'logger_service.dart';

/// Centralny serwis zarządzający wszystkimi typami powiadomień
class UnifiedNotificationService {
  static final UnifiedNotificationService _instance = UnifiedNotificationService._internal();
  static UnifiedNotificationService get instance => _instance;
  
  UnifiedNotificationService._internal();

  bool _isInitialized = false;

  /// Inicjalizuj wszystkie serwisy powiadomień
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Inicjalizuj powiadomienia lokalne
      await NotificationService.instance.initialize();
      
      // Inicjalizuj kalendarz
      await CalendarNotificationService.instance.initialize();
      
      // Inicjalizuj widżety
      await WidgetNotificationService.instance.initialize();

      _isInitialized = true;
      LoggerService.info('Unified Notification Service zainicjalizowany');
    } catch (e, stackTrace) {
      LoggerService.error('Błąd inicjalizacji Unified Notification Service', e, stackTrace);
      rethrow;
    }
  }

  /// Zaplanuj wszystkie typy powiadomień dla subskrypcji
  Future<void> scheduleAllNotifications({
    required Subscription subscription,
    required String userEmail,
    required String userName,
    bool includeLocalNotification = true,
    bool includeCalendarEvent = true,
    bool includeEmailReminder = true,
  }) async {
    if (!_isInitialized) {
      LoggerService.warning('Unified Notification Service nie jest zainicjalizowany');
      return;
    }

    final reminderDate = subscription.nextPaymentAt
        .subtract(Duration(days: subscription.reminderDays));

    try {
      // 1. Powiadomienie lokalne
      if (includeLocalNotification) {
        await NotificationService.instance.scheduleSubscriptionReminder(
          id: subscription.id.hashCode,
          title: 'Przypomnienie o płatności',
          body: 'Jutro płatność za ${subscription.title}: ${subscription.cost} ${subscription.currency}',
          scheduledDate: reminderDate,
          payload: subscription.id,
        );
      }

      // 2. Wydarzenie w kalendarzu
      if (includeCalendarEvent) {
        await CalendarNotificationService.instance.addSubscriptionReminder(
          title: subscription.title,
          description: 'Płatność za subskrypcję: ${subscription.cost} ${subscription.currency}',
          paymentDate: subscription.nextPaymentAt,
          reminderMinutes: subscription.reminderDays * 24 * 60,
        );
      }

      // 3. Powiadomienie email (opcjonalne, wymaga konfiguracji EmailJS)
      if (includeEmailReminder && userEmail.isNotEmpty) {
        await EmailNotificationService.instance.sendSubscriptionReminder(
          userEmail: userEmail,
          userName: userName,
          subscriptionName: subscription.title,
          paymentDate: subscription.nextPaymentAt,
          amount: subscription.cost,
          currency: subscription.currency,
        );
      }

      LoggerService.info('Zaplanowano wszystkie powiadomienia dla: ${subscription.title}');
    } catch (e, stackTrace) {
      LoggerService.error('Błąd planowania powiadomień', e, stackTrace);
    }
  }

  /// Anuluj wszystkie powiadomienia dla subskrypcji
  Future<void> cancelAllNotifications({
    required String subscriptionId,
    String? calendarEventId,
  }) async {
    try {
      // Anuluj powiadomienie lokalne
      await NotificationService.instance.cancelNotification(subscriptionId.hashCode);

      // Usuń z kalendarza jeśli mamy ID wydarzenia
      if (calendarEventId != null) {
        await CalendarNotificationService.instance.removeSubscriptionReminder(calendarEventId);
      }

      LoggerService.info('Anulowano wszystkie powiadomienia dla subskrypcji: $subscriptionId');
    } catch (e, stackTrace) {
      LoggerService.error('Błąd anulowania powiadomień', e, stackTrace);
    }
  }

  /// Zaktualizuj widżet z aktualnymi danymi
  Future<void> updateWidget({
    required List<Subscription> upcomingSubscriptions,
    required double totalMonthly,
  }) async {
    try {
      await WidgetNotificationService.instance.updateSubscriptionWidget(
        upcomingSubscriptions: upcomingSubscriptions,
        totalMonthly: totalMonthly,
      );
    } catch (e, stackTrace) {
      LoggerService.error('Błąd aktualizacji widżeta', e, stackTrace);
    }
  }

  /// Wyślij miesięczne podsumowanie
  Future<void> sendMonthlySummary({
    required String userEmail,
    required String userName,
    required List<Subscription> subscriptions,
  }) async {
    try {
      final totalAmount = subscriptions
          .map((sub) => _calculateMonthlyAmount(sub))
          .reduce((a, b) => a + b);

      final subscriptionsData = subscriptions.map((sub) => {
        'name': sub.title,
        'amount': _calculateMonthlyAmount(sub),
      }).toList();

      await EmailNotificationService.instance.sendMonthlySummary(
        userEmail: userEmail,
        userName: userName,
        subscriptions: subscriptionsData,
        totalAmount: totalAmount,
        currency: subscriptions.isNotEmpty ? subscriptions.first.currency : 'PLN',
      );

      LoggerService.info('Wysłano miesięczne podsumowanie');
    } catch (e, stackTrace) {
      LoggerService.error('Błąd wysyłania miesięcznego podsumowania', e, stackTrace);
    }
  }

  /// Oblicz miesięczną kwotę dla subskrypcji
  double _calculateMonthlyAmount(Subscription subscription) {
    switch (subscription.period.type) {
      case 'daily':
        return subscription.cost * 30; // Przybliżenie
      case 'weekly':
        return subscription.cost * 4.33; // ~4.33 tygodni w miesiącu
      case 'monthly':
        return subscription.cost;
      case 'yearly':
        return subscription.cost / 12;
      default:
        return subscription.cost; // Domyślnie miesięcznie
    }
  }

  /// Sprawdź czy powiadomienia są dostępne
  Future<Map<String, bool>> checkNotificationAvailability() async {
    return {
      'local': await NotificationService.instance.areNotificationsEnabled(),
      'calendar': true, // Kalendarz jest zawsze dostępny jeśli użytkownik da uprawnienia
      'email': true, // Email jest zawsze dostępny jeśli skonfigurowany
      'widget': await WidgetNotificationService.instance.areWidgetsSupported(),
    };
  }
}
