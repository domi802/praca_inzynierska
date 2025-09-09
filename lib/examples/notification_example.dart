import 'package:flutter/material.dart';
import '../core/services/notification_service.dart';
import '../features/subscriptions/data/subscription_model.dart';

/// Przykład użycia powiadomień lokalnych dla subskrypcji
class NotificationExample {
  
  /// Przykład: zaplanuj przypomnienie o Netflix
  static Future<void> scheduleNetflixReminder() async {
    // Przykładowa subskrypcja Netflix
    final netflixSubscription = Subscription(
      id: 'netflix_123',
      userId: 'user_456', 
      title: 'Netflix',
      cost: 49.99,
      currency: 'PLN',
      lastPaidAt: DateTime.now().subtract(Duration(days: 30)),
      nextPaymentAt: DateTime.now().add(Duration(days: 1)), // Jutro
      period: SubscriptionPeriod(type: 'monthly', interval: 1),
      iconPath: 'netflix_icon.png',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    // Zaplanuj powiadomienie na dzień przed płatnością
    final reminderDate = netflixSubscription.nextPaymentAt
        .subtract(Duration(days: 1)); // Dzień wcześniej

    await NotificationService.instance.scheduleSubscriptionReminder(
      id: netflixSubscription.id.hashCode, // Unikalny ID z nazwy
      title: '💳 Przypomnienie o płatności',
      body: 'Jutro płatność za Netflix: 49,99 PLN',
      scheduledDate: reminderDate,
      payload: netflixSubscription.id, // ID subskrypcji do obsługi kliknięcia
    );

    print('✅ Zaplanowano przypomnienie o Netflix na: $reminderDate');
  }

  /// Przykład: jak system obsługuje powiadomienie
  static void handleNotificationTap(String? payload) {
    if (payload != null) {
      print('👆 Użytkownik kliknął powiadomienie dla subskrypcji: $payload');
      
      // Tutaj możesz:
      // 1. Przejść do szczegółów subskrypcji
      // 2. Otworzyć ekran płatności
      // 3. Zapisać informację o kliknięciu
      
      // Przykład nawigacji:
      // Navigator.push(context, MaterialPageRoute(
      //   builder: (context) => SubscriptionDetailScreen(subscriptionId: payload)
      // ));
    }
  }

  /// Przykład: zaplanuj powiadomienia dla wszystkich aktywnych subskrypcji
  static Future<void> scheduleAllSubscriptionReminders(
    List<Subscription> subscriptions
  ) async {
    for (final subscription in subscriptions) {
      // Oblicz datę przypomnienia (domyślnie dzień przed)
      final reminderDate = subscription.nextPaymentAt
          .subtract(Duration(days: subscription.reminderDays));

      // Sprawdź czy data nie jest w przeszłości
      if (reminderDate.isAfter(DateTime.now())) {
        await NotificationService.instance.scheduleSubscriptionReminder(
          id: subscription.id.hashCode,
          title: '💳 Przypomnienie o płatności',
          body: 'Za ${subscription.reminderDays} ${subscription.reminderDays == 1 ? "dzień" : "dni"} płatność za ${subscription.title}: ${subscription.cost} ${subscription.currency}',
          scheduledDate: reminderDate,
          payload: subscription.id,
        );
        
        print('✅ Zaplanowano: ${subscription.title} na $reminderDate');
      }
    }
  }

  /// Przykład: anuluj powiadomienie gdy użytkownik opłaci subskrypcję
  static Future<void> cancelReminderAfterPayment(String subscriptionId) async {
    await NotificationService.instance.cancelNotification(
      subscriptionId.hashCode
    );
    
    print('❌ Anulowano przypomnienie dla: $subscriptionId');
  }
}

/// Widget pokazujący przykład użycia
class NotificationDemoWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () async {
            // Test powiadomienia za 10 sekund
            final testDate = DateTime.now().add(Duration(seconds: 10));
            
            await NotificationService.instance.scheduleSubscriptionReminder(
              id: 999,
              title: '🧪 Test powiadomienia',
              body: 'To jest testowe powiadomienie lokalne!',
              scheduledDate: testDate,
              payload: 'test',
            );
            
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Powiadomienie testowe za 10 sekund!'))
            );
          },
          child: Text('Test powiadomienia za 10s'),
        ),
        
        ElevatedButton(
          onPressed: () async {
            await NotificationExample.scheduleNetflixReminder();
            
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Zaplanowano przypomnienie Netflix!'))
            );
          },
          child: Text('Zaplanuj przypomnienie Netflix'),
        ),
        
        ElevatedButton(
          onPressed: () async {
            await NotificationService.instance.cancelAllNotifications();
            
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Anulowano wszystkie powiadomienia'))
            );
          },
          child: Text('Anuluj wszystkie powiadomienia'),
        ),
      ],
    );
  }
}
