import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

import 'subscription_model.dart';
import '../../../core/services/logger_service.dart';
import '../../../core/services/notification_service.dart';
import '../../../app/constants.dart';

/// Repozytorium do zarządzania subskrypcjami w Firestore
class SubscriptionRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final Uuid _uuid;

  SubscriptionRepository({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
    Uuid? uuid,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance,
        _uuid = uuid ?? const Uuid();

  /// Pobiera wszystkie subskrypcje aktualnego użytkownika
  Future<List<Subscription>> getSubscriptions() async {
    try {
      final userId = _getCurrentUserId();
      
      final QuerySnapshot snapshot = await _firestore
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .collection(AppConstants.subscriptionsCollection)
          .orderBy('nextPaymentAt')
          .get();

      return snapshot.docs
          .map((doc) => Subscription.fromMap(
                doc.data() as Map<String, dynamic>,
                doc.id,
              ))
          .toList();
    } catch (e) {
      LoggerService.error('Błąd podczas pobierania subskrypcji', e);
      throw Exception('Nie udało się pobrać subskrypcji');
    }
  }

  /// Pobiera pojedynczą subskrypcję po ID
  Future<Subscription?> getSubscription(String subscriptionId) async {
    try {
      final userId = _getCurrentUserId();
      
      final DocumentSnapshot doc = await _firestore
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .collection(AppConstants.subscriptionsCollection)
          .doc(subscriptionId)
          .get();

      if (!doc.exists || doc.data() == null) {
        return null;
      }

      return Subscription.fromMap(
        doc.data() as Map<String, dynamic>,
        doc.id,
      );
    } catch (e) {
      LoggerService.error('Błąd podczas pobierania subskrypcji', e);
      throw Exception('Nie udało się pobrać subskrypcji');
    }
  }

  /// Dodaje nową subskrypcję
  Future<String> addSubscription(Subscription subscription) async {
    try {
      final userId = _getCurrentUserId();
      final subscriptionId = _uuid.v4();
      
      final subscriptionWithId = subscription.copyWith(
        id: subscriptionId,
        userId: userId,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .collection(AppConstants.subscriptionsCollection)
          .doc(subscriptionId)
          .set(subscriptionWithId.toMap());

      // Zaplanuj powiadomienie
      await _scheduleNotification(subscriptionWithId);

      LoggerService.info('Dodano subskrypcję: ${subscription.title}');
      return subscriptionId;
    } catch (e) {
      LoggerService.error('Błąd podczas dodawania subskrypcji', e);
      throw Exception('Nie udało się dodać subskrypcji');
    }
  }

  /// Aktualizuje istniejącą subskrypcję
  Future<void> updateSubscription(Subscription subscription) async {
    try {
      final userId = _getCurrentUserId();
      
      final updatedSubscription = subscription.copyWith(
        updatedAt: DateTime.now(),
      );

      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .collection(AppConstants.subscriptionsCollection)
          .doc(subscription.id)
          .update(updatedSubscription.toMap());

      // Aktualizuj powiadomienie
      await _scheduleNotification(updatedSubscription);

      LoggerService.info('Zaktualizowano subskrypcję: ${subscription.title}');
    } catch (e) {
      LoggerService.error('Błąd podczas aktualizacji subskrypcji', e);
      throw Exception('Nie udało się zaktualizować subskrypcji');
    }
  }

  /// Usuwa subskrypcję
  Future<void> deleteSubscription(String subscriptionId) async {
    try {
      final userId = _getCurrentUserId();
      
      // Anuluj powiadomienie
      await NotificationService.instance.cancelNotification(
        subscriptionId.hashCode,
      );

      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .collection(AppConstants.subscriptionsCollection)
          .doc(subscriptionId)
          .delete();

      LoggerService.info('Usunięto subskrypcję: $subscriptionId');
    } catch (e) {
      LoggerService.error('Błąd podczas usuwania subskrypcji', e);
      throw Exception('Nie udało się usunąć subskrypcji');
    }
  }

  /// Oznacza subskrypcję jako opłaconą i oblicza następną datę płatności
  Future<void> markSubscriptionAsPaid(String subscriptionId) async {
    try {
      final subscription = await getSubscription(subscriptionId);
      if (subscription == null) {
        throw Exception('Nie znaleziono subskrypcji');
      }

      final now = DateTime.now();
      final nextPayment = _calculateNextPaymentDate(
        subscription.nextPaymentAt,
        subscription.period,
      );

      final updatedSubscription = subscription.copyWith(
        lastPaidAt: now,
        nextPaymentAt: nextPayment,
        updatedAt: now,
      );

      await updateSubscription(updatedSubscription);
      LoggerService.info('Oznaczono subskrypcję jako opłaconą: ${subscription.title}');
    } catch (e) {
      LoggerService.error('Błąd podczas oznaczania subskrypcji jako opłaconej', e);
      throw Exception('Nie udało się oznaczyć subskrypcji jako opłaconej');
    }
  }

  /// Pobiera subskrypcje wymagające przypomnienia
  Future<List<Subscription>> getSubscriptionsNeedingReminder() async {
    try {
      final subscriptions = await getSubscriptions();
      return subscriptions.where((sub) => sub.needsReminder).toList();
    } catch (e) {
      LoggerService.error('Błąd podczas pobierania subskrypcji wymagających przypomnienia', e);
      return [];
    }
  }

  /// Pobiera przeterminowane subskrypcje
  Future<List<Subscription>> getOverdueSubscriptions() async {
    try {
      final subscriptions = await getSubscriptions();
      return subscriptions.where((sub) => sub.isOverdue).toList();
    } catch (e) {
      LoggerService.error('Błąd podczas pobierania przeterminowanych subskrypcji', e);
      return [];
    }
  }

  /// Pobiera subskrypcje według kategorii
  Future<List<Subscription>> getSubscriptionsByCategory(String category) async {
    try {
      final userId = _getCurrentUserId();
      
      final QuerySnapshot snapshot = await _firestore
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .collection(AppConstants.subscriptionsCollection)
          .where('category', isEqualTo: category)
          .orderBy('nextPaymentAt')
          .get();

      return snapshot.docs
          .map((doc) => Subscription.fromMap(
                doc.data() as Map<String, dynamic>,
                doc.id,
              ))
          .toList();
    } catch (e) {
      LoggerService.error('Błąd podczas pobierania subskrypcji według kategorii', e);
      throw Exception('Nie udało się pobrać subskrypcji według kategorii');
    }
  }

  /// Oblicza następną datę płatności na podstawie okresu
  DateTime _calculateNextPaymentDate(DateTime currentDate, SubscriptionPeriod period) {
    switch (period.type) {
      case 'daily':
        return currentDate.add(Duration(days: period.interval));
      case 'weekly':
        return currentDate.add(Duration(days: 7 * period.interval));
      case 'monthly':
        return DateTime(
          currentDate.year,
          currentDate.month + period.interval,
          currentDate.day,
          currentDate.hour,
          currentDate.minute,
          currentDate.second,
        );
      case 'yearly':
        return DateTime(
          currentDate.year + period.interval,
          currentDate.month,
          currentDate.day,
          currentDate.hour,
          currentDate.minute,
          currentDate.second,
        );
      default:
        throw Exception('Nieznany typ okresu: ${period.type}');
    }
  }

  /// Planuje powiadomienie dla subskrypcji
  Future<void> _scheduleNotification(Subscription subscription) async {
    try {
      final reminderDate = subscription.nextPaymentAt.subtract(
        Duration(days: subscription.reminderDays),
      );

      // Sprawdź czy data przypomnienia jest w przyszłości
      if (reminderDate.isBefore(DateTime.now())) {
        return;
      }

      await NotificationService.instance.scheduleSubscriptionReminder(
        id: subscription.id.hashCode,
        title: 'Przypomnienie o płatności',
        body: 'Jutro płatność za ${subscription.title} - ${subscription.formattedCost}',
        scheduledDate: reminderDate,
        payload: subscription.id,
      );
    } catch (e) {
      LoggerService.error('Błąd podczas planowania powiadomienia', e);
    }
  }

  /// Pobiera ID aktualnego użytkownika
  String _getCurrentUserId() {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('Brak zalogowanego użytkownika');
    }
    return user.uid;
  }
}
