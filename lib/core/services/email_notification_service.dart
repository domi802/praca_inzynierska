import 'dart:convert';
import 'package:http/http.dart' as http;
import 'logger_service.dart';

/// Serwis do wysyłania powiadomień email przez EmailJS
class EmailNotificationService {
  static final EmailNotificationService _instance = EmailNotificationService._internal();
  static EmailNotificationService get instance => _instance;
  
  EmailNotificationService._internal();

  // Konfiguracja EmailJS - należy uzupełnić własnymi kluczami
  static const String _serviceId = 'YOUR_SERVICE_ID';
  static const String _templateId = 'YOUR_TEMPLATE_ID';
  static const String _publicKey = 'YOUR_PUBLIC_KEY';
  static const String _emailJsUrl = 'https://api.emailjs.com/api/v1.0/email/send';

  /// Wyślij email z przypomnieniem o subskrypcji
  Future<bool> sendSubscriptionReminder({
    required String userEmail,
    required String userName,
    required String subscriptionName,
    required DateTime paymentDate,
    required double amount,
    required String currency,
  }) async {
    try {
      final templateParams = {
        'to_email': userEmail,
        'user_name': userName,
        'subscription_name': subscriptionName,
        'payment_date': '${paymentDate.day}/${paymentDate.month}/${paymentDate.year}',
        'amount': '$amount $currency',
        'days_until_payment': paymentDate.difference(DateTime.now()).inDays,
      };

      final response = await http.post(
        Uri.parse(_emailJsUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'service_id': _serviceId,
          'template_id': _templateId,
          'user_id': _publicKey,
          'template_params': templateParams,
        }),
      );

      if (response.statusCode == 200) {
        LoggerService.info('Email wysłany pomyślnie do: $userEmail');
        return true;
      } else {
        LoggerService.error('Błąd wysyłania emaila', 
          'Status: ${response.statusCode}, Body: ${response.body}', null);
        return false;
      }
    } catch (e, stackTrace) {
      LoggerService.error('Błąd wysyłania powiadomienia email', e, stackTrace);
      return false;
    }
  }

  /// Wyślij podsumowanie miesięczne
  Future<bool> sendMonthlySummary({
    required String userEmail,
    required String userName,
    required List<Map<String, dynamic>> subscriptions,
    required double totalAmount,
    required String currency,
  }) async {
    try {
      final subscriptionsList = subscriptions
          .map((sub) => '• ${sub['name']}: ${sub['amount']} $currency')
          .join('\n');

      final templateParams = {
        'to_email': userEmail,
        'user_name': userName,
        'subscriptions_list': subscriptionsList,
        'total_amount': '$totalAmount $currency',
        'month_year': '${DateTime.now().month}/${DateTime.now().year}',
      };

      final response = await http.post(
        Uri.parse(_emailJsUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'service_id': _serviceId,
          'template_id': 'monthly_summary_template', // Inny szablon
          'user_id': _publicKey,
          'template_params': templateParams,
        }),
      );

      return response.statusCode == 200;
    } catch (e, stackTrace) {
      LoggerService.error('Błąd wysyłania podsumowania miesięcznego', e, stackTrace);
      return false;
    }
  }
}
