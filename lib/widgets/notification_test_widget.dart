import 'package:flutter/material.dart';
import '../core/services/notification_service.dart';

class NotificationTestWidget extends StatefulWidget {
  @override
  _NotificationTestWidgetState createState() => _NotificationTestWidgetState();
}

class _NotificationTestWidgetState extends State<NotificationTestWidget> {
  bool _notificationsEnabled = false;

  @override
  void initState() {
    super.initState();
    _checkNotificationPermissions();
  }

  Future<void> _checkNotificationPermissions() async {
    final enabled = await NotificationService.instance.areNotificationsEnabled();
    setState(() {
      _notificationsEnabled = enabled;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test Powiadomień'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Status powiadomień
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Icon(
                      _notificationsEnabled ? Icons.notifications_active : Icons.notifications_off,
                      size: 48,
                      color: _notificationsEnabled ? Colors.green : Colors.red,
                    ),
                    SizedBox(height: 8),
                    Text(
                      _notificationsEnabled ? 'Powiadomienia WŁĄCZONE' : 'Powiadomienia WYŁĄCZONE',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: _notificationsEnabled ? Colors.green : Colors.red,
                      ),
                    ),
                    if (!_notificationsEnabled) ...[
                      SizedBox(height: 8),
                      Text(
                        'Włącz powiadomienia w ustawieniach telefonu',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            
            // Przyciski testowe
            ElevatedButton.icon(
              onPressed: () => _scheduleTestNotification(10),
              icon: Icon(Icons.access_time),
              label: Text('Test za 10 sekund'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: EdgeInsets.all(16),
              ),
            ),
            SizedBox(height: 12),
            
            ElevatedButton.icon(
              onPressed: () => _scheduleTestNotification(60),
              icon: Icon(Icons.timer),
              label: Text('Test za 1 minutę'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                padding: EdgeInsets.all(16),
              ),
            ),
            SizedBox(height: 12),
            
            ElevatedButton.icon(
              onPressed: _scheduleNetflixTest,
              icon: Icon(Icons.movie),
              label: Text('Test Netflix jutro'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: EdgeInsets.all(16),
              ),
            ),
            SizedBox(height: 12),
            
            ElevatedButton.icon(
              onPressed: _scheduleSpotifyTest,
              icon: Icon(Icons.music_note),
              label: Text('Test Spotify za 30s'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: EdgeInsets.all(16),
              ),
            ),
            SizedBox(height: 20),
            
            // Przycisk anulowania
            ElevatedButton.icon(
              onPressed: _cancelAllNotifications,
              icon: Icon(Icons.clear_all),
              label: Text('Anuluj wszystkie'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
                foregroundColor: Colors.white,
                padding: EdgeInsets.all(16),
              ),
            ),
            SizedBox(height: 20),
            
            // Instrukcje
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '📋 Instrukcje testowania:',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    SizedBox(height: 8),
                    Text('1. Kliknij "Test za 10 sekund"'),
                    Text('2. Zminimalizuj aplikację'),
                    Text('3. Poczekaj na powiadomienie'),
                    Text('4. Kliknij powiadomienie aby wrócić do app'),
                    SizedBox(height: 8),
                    Text(
                      '💡 Jeśli nie widzisz powiadomień, sprawdź ustawienia telefonu!',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Colors.blue[700],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _scheduleTestNotification(int seconds) async {
    final testDate = DateTime.now().add(Duration(seconds: seconds));
    
    await NotificationService.instance.scheduleSubscriptionReminder(
      id: DateTime.now().millisecondsSinceEpoch,
      title: '🧪 Test Powiadomienia',
      body: 'To jest testowe powiadomienie lokalne z aplikacji Subskrypcje!',
      scheduledDate: testDate,
      payload: 'test_notification',
    );
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('✅ Zaplanowano powiadomienie testowe za ${seconds}s'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
      ),
    );
  }

  Future<void> _scheduleNetflixTest() async {
    final tomorrowDate = DateTime.now().add(Duration(days: 1));
    
    await NotificationService.instance.scheduleSubscriptionReminder(
      id: 'netflix_test'.hashCode,
      title: '💳 Przypomnienie o płatności',
      body: 'Jutro płatność za Netflix: 49,99 PLN',
      scheduledDate: tomorrowDate,
      payload: 'netflix_subscription',
    );
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('✅ Zaplanowano przypomnienie Netflix na jutro'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ),
    );
  }

  Future<void> _scheduleSpotifyTest() async {
    final testDate = DateTime.now().add(Duration(seconds: 30));
    
    await NotificationService.instance.scheduleSubscriptionReminder(
      id: 'spotify_test'.hashCode,
      title: '🎵 Przypomnienie o płatności',
      body: 'Wkrótce płatność za Spotify Premium: 19,99 PLN',
      scheduledDate: testDate,
      payload: 'spotify_subscription',
    );
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('✅ Zaplanowano przypomnienie Spotify za 30s'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
      ),
    );
  }

  Future<void> _cancelAllNotifications() async {
    await NotificationService.instance.cancelAllNotifications();
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('❌ Anulowano wszystkie powiadomienia'),
        backgroundColor: Colors.grey,
        duration: Duration(seconds: 2),
      ),
    );
  }
}
