import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';

class PeriodHelper {
  static String getLocalizedPeriod(BuildContext context, String period) {
    final localizations = AppLocalizations.of(context)!;
    
    switch (period.toLowerCase()) {
      case 'daily':
        return localizations.periodDaily;
      case 'weekly':
        return localizations.periodWeekly;
      case 'monthly':
        return localizations.periodMonthly;
      case 'yearly':
        return localizations.periodYearly;
      case '3_days':
      case 'every_3_days':
        return localizations.period3Days;
      case 'biweekly':
        return localizations.periodBiweekly;
      case 'quarterly':
        return localizations.periodQuarterly;
      default:
        return period;
    }
  }

  static String getLocalizedPeriodFromDays(BuildContext context, int daysBetween) {
    final localizations = AppLocalizations.of(context)!;
    
    switch (daysBetween) {
      case 1:
        return localizations.periodDaily;
      case 3:
        return localizations.period3Days;
      case 7:
        return localizations.periodWeekly;
      case 14:
        return localizations.periodBiweekly;
      case 30:
      case 31:
        return localizations.periodMonthly;
      case 90:
      case 91:
      case 92:
        return localizations.periodQuarterly;
      case 365:
      case 366:
        return localizations.periodYearly;
      default:
        return '$daysBetween ${localizations.daysBefore}';
    }
  }
}
