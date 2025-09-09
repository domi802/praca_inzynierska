import 'package:device_calendar/device_calendar.dart';
import 'package:timezone/timezone.dart' as tz;
import 'logger_service.dart';

/// Serwis do tworzenia przypomnień w kalendarzu systemowym
class CalendarNotificationService {
  static final CalendarNotificationService _instance = CalendarNotificationService._internal();
  static CalendarNotificationService get instance => _instance;
  
  CalendarNotificationService._internal();

  final DeviceCalendarPlugin _deviceCalendarPlugin = DeviceCalendarPlugin();
  String? _defaultCalendarId;

  /// Inicjalizacja serwisu kalendarza
  Future<bool> initialize() async {
    try {
      // Sprawdź uprawnienia
      var permissionsGranted = await _deviceCalendarPlugin.hasPermissions();
      if (permissionsGranted.isSuccess && !permissionsGranted.data!) {
        permissionsGranted = await _deviceCalendarPlugin.requestPermissions();
        if (!permissionsGranted.isSuccess || !permissionsGranted.data!) {
          LoggerService.warning('Brak uprawnień do kalendarza');
          return false;
        }
      }

      // Znajdź domyślny kalendarz
      final calendarsResult = await _deviceCalendarPlugin.retrieveCalendars();
      if (calendarsResult.isSuccess && calendarsResult.data!.isNotEmpty) {
        // Wybierz pierwszy dostępny kalendarz lub znajdź główny
        _defaultCalendarId = calendarsResult.data!
            .firstWhere((cal) => !cal.isReadOnly!, orElse: () => calendarsResult.data!.first)
            .id;
        
        LoggerService.info('Kalendarz zainicjalizowany: $_defaultCalendarId');
        return true;
      }
      
      return false;
    } catch (e, stackTrace) {
      LoggerService.error('Błąd inicjalizacji kalendarza', e, stackTrace);
      return false;
    }
  }

  /// Dodaj przypomnienie o subskrypcji do kalendarza
  Future<bool> addSubscriptionReminder({
    required String title,
    required String description,
    required DateTime paymentDate,
    int reminderMinutes = 1440, // 24 godziny przed
  }) async {
    if (_defaultCalendarId == null) {
      LoggerService.warning('Kalendarz nie jest zainicjalizowany');
      return false;
    }

    try {
      final event = Event(
        _defaultCalendarId,
        title: '💳 $title - Płatność',
        description: description,
        start: TZDateTime.from(paymentDate, tz.local),
        end: TZDateTime.from(paymentDate.add(Duration(hours: 1)), tz.local),
        allDay: false,
      );

      // Dodaj przypomnienie
      event.reminders = [
        Reminder(minutes: reminderMinutes), // Dzień przed
        Reminder(minutes: 60), // Godzina przed
      ];

      final createEventResult = await _deviceCalendarPlugin.createOrUpdateEvent(event);
      
      if (createEventResult != null && createEventResult.isSuccess) {
        LoggerService.info('Dodano wydarzenie do kalendarza: $title');
        return true;
      }
      
      return false;
    } catch (e, stackTrace) {
      LoggerService.error('Błąd dodawania wydarzenia do kalendarza', e, stackTrace);
      return false;
    }
  }

  /// Usuń przypomnienie z kalendarza
  Future<bool> removeSubscriptionReminder(String eventId) async {
    if (_defaultCalendarId == null) return false;

    try {
      final deleteResult = await _deviceCalendarPlugin.deleteEvent(_defaultCalendarId, eventId);
      return deleteResult.isSuccess;
    } catch (e, stackTrace) {
      LoggerService.error('Błąd usuwania wydarzenia z kalendarza', e, stackTrace);
      return false;
    }
  }
}
