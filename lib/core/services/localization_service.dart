import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';

/// Serwis do tłumaczeń bez kontekstu
class LocalizationService {
  static AppLocalizations? _instance;
  
  /// Inicjalizuj serwis z kontekstem
  static void initialize(BuildContext context) {
    _instance = AppLocalizations.of(context);
  }
  
  /// Pobierz instancję tłumaczeń
  static AppLocalizations? get instance => _instance;
  
  /// Komunikaty błędów uwierzytelnienia
  static String getAuthError(String errorCode) {
    final localizations = _instance;
    if (localizations == null) {
      // Fallback to English if no localization available
      switch (errorCode) {
        case 'user-not-found':
        case 'wrong-password':
        case 'invalid-email':
        case 'invalid-credential':
          return 'Invalid login or password';
        case 'email-already-in-use':
          return 'Account with this email already exists';
        case 'weak-password':
          return 'Password is too weak';
        case 'user-disabled':
          return 'User account has been disabled';
        case 'too-many-requests':
          return 'Too many login attempts. Please try again later';
        case 'operation-not-allowed':
          return 'Operation is not allowed';
        case 'network-request-failed':
          return 'No internet connection';
        default:
          return 'An error occurred. Please try again later';
      }
    }
    
    // Use localized strings
    switch (errorCode) {
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-email':
      case 'invalid-credential':
        return localizations.errorInvalidLogin;
      case 'email-already-in-use':
        return localizations.errorEmailAlreadyExists;
      case 'weak-password':
        return localizations.errorWeakPasswordAuth;
      case 'user-disabled':
        return localizations.errorUserDisabled;
      case 'too-many-requests':
        return localizations.errorTooManyRequests;
      case 'operation-not-allowed':
        return localizations.errorOperationNotAllowed;
      case 'network-request-failed':
        return localizations.errorNetworkFailed;
      case 'user-data-not-found':
        return localizations.errorUserDataNotFound;
      default:
        return localizations.errorGenericAuth;
    }
  }
  
  static String getUnexpectedError() {
    return _instance?.errorUnexpected ?? 'An unexpected error occurred';
  }
}
