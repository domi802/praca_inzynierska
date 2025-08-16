/// Stałe globalne aplikacji
class AppConstants {
  // Nazwy kolekcji Firebase
  static const String usersCollection = 'users';
  static const String subscriptionsCollection = 'subscriptions';
  
  // Nazwy pól w Firestore
  static const String uidField = 'uid';
  static const String emailField = 'email';
  static const String createdAtField = 'createdAt';
  static const String updatedAtField = 'updatedAt';
  
  // Firebase Storage ścieżki
  static const String iconsStoragePath = 'users/{uid}/icons';
  
  // Domyślne wartości
  static const int defaultReminderDays = 1;
  static const bool defaultNotifyEnabled = true;
  
  // Typy okresów płatności
  static const String periodTypeDaily = 'daily';
  static const String periodTypeWeekly = 'weekly';
  static const String periodTypeMonthly = 'monthly';
  static const String periodTypeYearly = 'yearly';
  
  // Waluty
  static const List<String> supportedCurrencies = [
    'PLN',
    'USD',
    'EUR',
    'GBP',
    'CHF',
    'CZK',
    'SEK',
    'NOK',
    'DKK',
  ];
  
  // Kategorie subskrypcji (predefiniowane)
  static const List<String> defaultCategories = [
    'Rozrywka',
    'Muzyka',
    'Video',
    'Gaming',
    'Productivity',
    'Edukacja',
    'Fitness',
    'Zdrowie',
    'Shopping',
    'Transport',
    'Inne',
  ];
  
  // Limity
  static const int maxSubscriptionTitleLength = 50;
  static const int maxNotesLength = 500;
  static const double maxCost = 99999.99;
  static const int maxReminderDays = 30;
  
  // Nazwy shared preferences
  static const String prefKeyFirstLaunch = 'first_launch';
  static const String prefKeyNotificationsEnabled = 'notifications_enabled';
  static const String prefKeyThemeMode = 'theme_mode';
  static const String prefKeyLanguage = 'language';
  
  // Nazwy kanałów powiadomień
  static const String notificationChannelId = 'subscription_reminders';
  static const String notificationChannelName = 'Przypomnienia o subskrypcjach';
  static const String notificationChannelDescription = 
      'Powiadomienia o zbliżających się płatnościach za subskrypcje';
  
  // Kody błędów
  static const String errorCodeNetworkError = 'network_error';
  static const String errorCodeAuthError = 'auth_error';
  static const String errorCodePermissionDenied = 'permission_denied';
  static const String errorCodeNotFound = 'not_found';
  static const String errorCodeUnknown = 'unknown_error';
  
  // Regex patterns
  static const String emailRegexPattern = 
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  
  // Domyślne ikony subskrypcji
  static const Map<String, String> defaultIcons = {
    'netflix': 'assets/icons/netflix.png',
    'spotify': 'assets/icons/spotify.png',
    'amazon': 'assets/icons/amazon.png',
    'apple': 'assets/icons/apple.png',
    'google': 'assets/icons/google.png',
    'microsoft': 'assets/icons/microsoft.png',
    'adobe': 'assets/icons/adobe.png',
    'github': 'assets/icons/github.png',
    'default': 'assets/icons/default_subscription.png',
  };
}
