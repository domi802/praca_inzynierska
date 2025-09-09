import 'package:home_widget/home_widget.dart';
import '../../features/subscriptions/data/subscription_model.dart';
import 'logger_service.dart';

/// Serwis do zarządzania widżetami systemowymi (głównie Android)
class WidgetNotificationService {
  static final WidgetNotificationService _instance = WidgetNotificationService._internal();
  static WidgetNotificationService get instance => _instance;
  
  WidgetNotificationService._internal();

  static const String _androidWidgetName = 'SubscriptionWidgetProvider';
  static const String _iOSWidgetName = 'SubscriptionWidget';

  /// Inicjalizuj serwis widżetów
  Future<bool> initialize() async {
    try {
      await HomeWidget.setAppGroupId('group.subscription.manager');
      LoggerService.info('Serwis widżetów zainicjalizowany');
      return true;
    } catch (e, stackTrace) {
      LoggerService.error('Błąd inicjalizacji serwisu widżetów', e, stackTrace);
      return false;
    }
  }

  /// Zaktualizuj widżet z nadchodzącymi płatnościami
  Future<void> updateSubscriptionWidget({
    required List<Subscription> upcomingSubscriptions,
    required double totalMonthly,
  }) async {
    try {
      // Przygotuj dane dla widżeta
      final nextSubscription = upcomingSubscriptions.isNotEmpty 
          ? upcomingSubscriptions.first 
          : null;

      if (nextSubscription != null) {
        final daysUntil = nextSubscription.nextPaymentAt.difference(DateTime.now()).inDays;
        
        await HomeWidget.saveWidgetData<String>('subscription_name', nextSubscription.title);
        await HomeWidget.saveWidgetData<double>('subscription_cost', nextSubscription.cost);
        await HomeWidget.saveWidgetData<int>('days_until', daysUntil);
        await HomeWidget.saveWidgetData<String>('payment_date', 
          '${nextSubscription.nextPaymentAt.day}/${nextSubscription.nextPaymentAt.month}');
      } else {
        await HomeWidget.saveWidgetData<String>('subscription_name', 'Brak subskrypcji');
        await HomeWidget.saveWidgetData<double>('subscription_cost', 0.0);
        await HomeWidget.saveWidgetData<int>('days_until', 0);
        await HomeWidget.saveWidgetData<String>('payment_date', '');
      }

      await HomeWidget.saveWidgetData<double>('total_monthly', totalMonthly);
      await HomeWidget.saveWidgetData<int>('total_subscriptions', upcomingSubscriptions.length);
      
      // Zaktualizuj widżet
      await HomeWidget.updateWidget(
        name: _androidWidgetName,
        androidName: _androidWidgetName,
        iOSName: _iOSWidgetName,
      );

      LoggerService.info('Widżet zaktualizowany pomyślnie');
    } catch (e, stackTrace) {
      LoggerService.error('Błąd aktualizacji widżeta', e, stackTrace);
    }
  }

  /// Wyczyść dane widżeta
  Future<void> clearWidgetData() async {
    try {
      await HomeWidget.saveWidgetData<String>('subscription_name', '');
      await HomeWidget.saveWidgetData<double>('subscription_cost', 0.0);
      await HomeWidget.saveWidgetData<int>('days_until', 0);
      await HomeWidget.saveWidgetData<String>('payment_date', '');
      await HomeWidget.saveWidgetData<double>('total_monthly', 0.0);
      await HomeWidget.saveWidgetData<int>('total_subscriptions', 0);

      await HomeWidget.updateWidget(
        name: _androidWidgetName,
        androidName: _androidWidgetName,
        iOSName: _iOSWidgetName,
      );

      LoggerService.info('Dane widżeta wyczyszczone');
    } catch (e, stackTrace) {
      LoggerService.error('Błąd czyszczenia danych widżeta', e, stackTrace);
    }
  }

  /// Sprawdź czy widżety są dostępne na platformie
  Future<bool> areWidgetsSupported() async {
    try {
      // Sprawdź czy platforma obsługuje widżety
      return await HomeWidget.isRequestPinWidgetSupported() ?? false;
    } catch (e) {
      return false;
    }
  }

  /// Poproś użytkownika o dodanie widżeta
  Future<void> requestPinWidget() async {
    try {
      final supported = await areWidgetsSupported();
      if (supported) {
        await HomeWidget.requestPinWidget(
          androidName: _androidWidgetName,
        );
        LoggerService.info('Poproszono o dodanie widżeta');
      } else {
        LoggerService.warning('Widżety nie są obsługiwane na tej platformie');
      }
    } catch (e, stackTrace) {
      LoggerService.error('Błąd podczas prośby o dodanie widżeta', e, stackTrace);
    }
  }
}
