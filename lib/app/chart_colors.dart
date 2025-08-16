import 'package:flutter/material.dart';

/// Klasa pomocnicza zawierająca kolory do wykresów i wizualizacji danych
class ChartColors {
  static const List<Color> palette = [
    Color(0xFFFFA726), // Primary - pomarańczowy
    Color(0xFF29B6F6), // Secondary - niebieski
    Color(0xFF66BB6A), // Success - zielony
    Color(0xFFAB47BC), // Purple - fioletowy
    Color(0xFFE53935), // Error - czerwony
    Color(0xFFFFB300), // Warning - żółty
    Color(0xFF9E9E9E), // Grey - szary
  ];

  /// Pobiera kolor z palety według indeksu (z rotacją)
  static Color getColor(int index) {
    return palette[index % palette.length];
  }

  /// Pobiera kolor dla konkretnej kategorii subskrypcji
  static Color getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'rozrywka':
        return Color(0xFFE53935); // Error (czerwony)
      case 'muzyka':
        return Color(0xFFAB47BC); // Purple (fioletowy)
      case 'video':
        return Color(0xFF29B6F6); // Secondary (niebieski)
      case 'gry':
        return Color(0xFF66BB6A); // Success (zielony)
      case 'produktywność':
        return Color(0xFFFFB300); // Warning (żółty)
      case 'edukacja':
        return Color(0xFF0288D1); // Secondary variant (ciemnoniebieski)
      case 'sport':
        return Color(0xFFFFA726); // Primary (pomarańczowy)
      case 'zdrowie':
        return Color(0xFFFB8C00); // Primary variant (ciemnopomarańczowy)
      case 'finanse':
        return Color(0xFFFFB300); // Warning (żółty)
      default:
        return Color(0xFF9E9E9E); // Grey (szary)
    }
  }

  /// Kolory statusu płatności
  static const Color overdue = Color(0xFFE53935); // Czerwony
  static const Color dueToday = Color(0xFFFFB300); // Żółty
  static const Color dueSoon = Color(0xFFFFA726); // Pomarańczowy
  static const Color onTime = Color(0xFF66BB6A); // Zielony

  /// Pobiera kolor statusu płatności według liczby dni do terminu
  static Color getPaymentStatusColor(int daysUntilPayment) {
    if (daysUntilPayment < 0) return overdue;
    if (daysUntilPayment == 0) return dueToday;
    if (daysUntilPayment <= 3) return dueSoon;
    return onTime;
  }
}
