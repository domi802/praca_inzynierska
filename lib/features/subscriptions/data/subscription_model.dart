import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Model reprezentujący okres płatności subskrypcji
class SubscriptionPeriod extends Equatable {
  final String type; // 'daily', 'weekly', 'monthly', 'yearly'
  final int interval; // Interwał (np. co 2 miesiące = interval: 2)

  const SubscriptionPeriod({
    required this.type,
    required this.interval,
  });

  /// Tworzy instancję z mapy
  factory SubscriptionPeriod.fromMap(Map<String, dynamic> map) {
    return SubscriptionPeriod(
      type: map['type'] as String,
      interval: map['interval'] as int,
    );
  }

  /// Konwertuje do mapy
  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'interval': interval,
    };
  }

  /// Zwraca opis okresu po polsku
  String get description {
    String typeText;
    switch (type) {
      case 'daily':
        typeText = interval == 1 ? 'dzień' : 'dni';
        break;
      case 'weekly':
        typeText = interval == 1 ? 'tydzień' : 'tygodni';
        break;
      case 'monthly':
        typeText = interval == 1 ? 'miesiąc' : 'miesięcy';
        break;
      case 'yearly':
        typeText = interval == 1 ? 'rok' : 'lat';
        break;
      default:
        typeText = 'nieznany';
    }
    
    return interval == 1 ? 'co $typeText' : 'co $interval $typeText';
  }

  @override
  List<Object?> get props => [type, interval];
}

/// Model reprezentujący subskrypcję użytkownika
class Subscription extends Equatable {
  final String id;
  final String userId;
  final String title;
  final String? category;
  final double cost;
  final String currency; // ISO format (np. "PLN")
  final DateTime lastPaidAt;
  final DateTime nextPaymentAt;
  final SubscriptionPeriod period;
  final String? notes;
  final bool notify; // Zawsze true zgodnie ze specyfikacją
  final int reminderDays; // Zawsze 1 zgodnie ze specyfikacją
  final String? calendarEventId;
  final String iconPath; // Ścieżka do ikony w Firebase Storage
  final DateTime createdAt;
  final DateTime updatedAt;

  const Subscription({
    required this.id,
    required this.userId,
    required this.title,
    this.category,
    required this.cost,
    required this.currency,
    required this.lastPaidAt,
    required this.nextPaymentAt,
    required this.period,
    this.notes,
    this.notify = true,
    this.reminderDays = 1,
    this.calendarEventId,
    required this.iconPath,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Tworzy instancję Subscription z mapy (Firestore)
  factory Subscription.fromMap(Map<String, dynamic> map, String id) {
    return Subscription(
      id: id,
      userId: map['userId'] as String,
      title: map['title'] as String,
      category: map['category'] as String?,
      cost: (map['cost'] as num).toDouble(),
      currency: map['currency'] as String,
      lastPaidAt: (map['lastPaidAt'] as Timestamp).toDate(),
      nextPaymentAt: (map['nextPaymentAt'] as Timestamp).toDate(),
      period: SubscriptionPeriod.fromMap(map['period'] as Map<String, dynamic>),
      notes: map['notes'] as String?,
      notify: map['notify'] as bool? ?? true,
      reminderDays: map['reminderDays'] as int? ?? 1,
      calendarEventId: map['calendarEventId'] as String?,
      iconPath: map['iconPath'] as String,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
    );
  }

  /// Konwertuje Subscription do mapy (Firestore)
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'title': title,
      'category': category,
      'cost': cost,
      'currency': currency,
      'lastPaidAt': Timestamp.fromDate(lastPaidAt),
      'nextPaymentAt': Timestamp.fromDate(nextPaymentAt),
      'period': period.toMap(),
      'notes': notes,
      'notify': notify,
      'reminderDays': reminderDays,
      'calendarEventId': calendarEventId,
      'iconPath': iconPath,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  /// Tworzy kopię z możliwością zmiany niektórych pól
  Subscription copyWith({
    String? id,
    String? userId,
    String? title,
    String? category,
    double? cost,
    String? currency,
    DateTime? lastPaidAt,
    DateTime? nextPaymentAt,
    SubscriptionPeriod? period,
    String? notes,
    bool? notify,
    int? reminderDays,
    String? calendarEventId,
    String? iconPath,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Subscription(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      category: category ?? this.category,
      cost: cost ?? this.cost,
      currency: currency ?? this.currency,
      lastPaidAt: lastPaidAt ?? this.lastPaidAt,
      nextPaymentAt: nextPaymentAt ?? this.nextPaymentAt,
      period: period ?? this.period,
      notes: notes ?? this.notes,
      notify: notify ?? this.notify,
      reminderDays: reminderDays ?? this.reminderDays,
      calendarEventId: calendarEventId ?? this.calendarEventId,
      iconPath: iconPath ?? this.iconPath,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Sprawdza czy subskrypcja jest przeterminowana
  bool get isOverdue {
    return DateTime.now().isAfter(nextPaymentAt);
  }

  /// Sprawdza czy subskrypcja wymaga przypomnienia
  bool get needsReminder {
    final reminderDate = nextPaymentAt.subtract(Duration(days: reminderDays));
    final now = DateTime.now();
    return now.isAfter(reminderDate) && now.isBefore(nextPaymentAt);
  }

  /// Zwraca liczbę dni do następnej płatności
  int get daysUntilNextPayment {
    final now = DateTime.now();
    final difference = nextPaymentAt.difference(now).inDays;
    return difference < 0 ? 0 : difference;
  }

  /// Formatuje koszt z walutą
  String get formattedCost {
    return '${cost.toStringAsFixed(2)} $currency';
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        title,
        category,
        cost,
        currency,
        lastPaidAt,
        nextPaymentAt,
        period,
        notes,
        notify,
        reminderDays,
        calendarEventId,
        iconPath,
        createdAt,
        updatedAt,
      ];

  @override
  String toString() {
    return 'Subscription(id: $id, title: $title, cost: $formattedCost, nextPayment: $nextPaymentAt)';
  }
}
