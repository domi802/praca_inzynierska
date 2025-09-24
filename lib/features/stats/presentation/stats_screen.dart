import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../subscriptions/data/subscription_model.dart';
import '../../subscriptions/logic/subscriptions_bloc.dart';
import '../../../l10n/app_localizations.dart';

/// Ekran statystyk wydatków
class StatsScreen extends StatelessWidget {
  const StatsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.stats),
      ),
      body: BlocBuilder<SubscriptionsBloc, SubscriptionsState>(
        builder: (context, state) {
          if (state is SubscriptionsLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (state is SubscriptionsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 64, color: Color(0xFFE53935)),
                  const SizedBox(height: 16),
                  Text('${localizations.error}: ${state.message}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<SubscriptionsBloc>().add(SubscriptionsLoadRequested());
                    },
                    child: Text(localizations.tryAgain),
                  ),
                ],
              ),
            );
          }
          
          // Obsługa stanu odświeżania - traktuj jak załadowane dane
          if (state is SubscriptionsRefreshing && state.subscriptions.isNotEmpty) {
            // Konwertuj na SubscriptionsLoaded żeby użyć istniejącego kodu
            state = SubscriptionsLoaded(
              subscriptions: state.subscriptions,
              totalMonthlyCost: _calculateMonthlyCost(state.subscriptions),
              totalYearlyCost: _calculateYearlyCost(state.subscriptions),
            );
          }
          
          if (state is! SubscriptionsLoaded) {
            return Center(
              child: Text(localizations.noDataToDisplay),
            );
          }

          if (state.subscriptions.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.analytics,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    AppLocalizations.of(context)!.noSubscriptions,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    AppLocalizations.of(context)!.addSubscriptionsToSeeStats,
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Podsumowanie kosztów
                _buildCostSummary(context, state),
                const SizedBox(height: 20),
                
                // Statystyki według kategorii
                _buildCategoryStats(context, state.subscriptions),
                const SizedBox(height: 20),
                
                // Statystyki według okresu
                _buildPeriodStats(context, state.subscriptions),
                const SizedBox(height: 20),
                
                // Najbardziej kosztowne subskrypcje
                _buildMostExpensive(context, state.subscriptions),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCostSummary(BuildContext context, SubscriptionsLoaded state) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.account_balance_wallet,
                  color: Color(0xFF66BB6A),
                  size: 24,
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    AppLocalizations.of(context)!.costSummary,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _buildCostCard(
                    AppLocalizations.of(context)!.monthlyLabel,
                    '${state.totalMonthlyCost.toStringAsFixed(2)} PLN',
                    Icons.calendar_month,
                    Color(0xFF29B6F6),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildCostCard(
                    AppLocalizations.of(context)!.yearlyLabel,
                    '${state.totalYearlyCost.toStringAsFixed(2)} PLN',
                    Icons.calendar_today,
                    Color(0xFF66BB6A),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: _buildCostCard(
                AppLocalizations.of(context)!.averageCostPerSubscription,
                '${(state.totalMonthlyCost / state.subscriptions.length).toStringAsFixed(2)} PLN${AppLocalizations.of(context)!.perMonth}',
                Icons.savings,
                Color(0xFFFFB300),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCostCard(String title, String amount, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: color,
              fontSize: 13,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            amount,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryStats(BuildContext context, List<Subscription> subscriptions) {
    final categoryStats = <String, double>{};
    final categoryCounts = <String, int>{};
    
    for (final subscription in subscriptions) {
      final category = subscription.category ?? AppLocalizations.of(context)!.categoryOther;
      categoryStats[category] = (categoryStats[category] ?? 0) + subscription.cost;
      categoryCounts[category] = (categoryCounts[category] ?? 0) + 1;
    }
    
    final sortedCategories = categoryStats.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.category,
                  color: Color(0xFFAB47BC),
                  size: 24,
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    AppLocalizations.of(context)!.expensesByCategory,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...sortedCategories.map((entry) => _buildCategoryItem(
              context,
              entry.key,
              entry.value,
              categoryCounts[entry.key]!,
              categoryStats.values.reduce((a, b) => a + b),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryItem(BuildContext context, String category, double amount, int count, double total) {
    final percentage = (amount / total * 100);
    
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Ikona kategorii
              Icon(
                _getCategoryIcon(category),
                size: 20,
                color: _getCategoryColor(category),
              ),
              const SizedBox(width: 10),
              // Nazwa kategorii
              Expanded(
                child: Text(
                  _getLocalizedCategoryName(context, category),
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              // Licznik
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  count.toString(),
                  style: const TextStyle(fontSize: 11),
                ),
              ),
              const SizedBox(width: 12),
              // Kwota i procenty w kolumnie
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 100,
                    child: Text(
                      '${amount.toStringAsFixed(2)} PLN',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.end,
                      maxLines: 1,
                    ),
                  ),
                  Text(
                    '${percentage.toStringAsFixed(1)}%',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: percentage / 100,
            backgroundColor: Colors.grey.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(_getCategoryColor(category)),
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodStats(BuildContext context, List<Subscription> subscriptions) {
    final periodStats = <String, int>{};
    
    for (final subscription in subscriptions) {
      final period = subscription.period.type;
      periodStats[period] = (periodStats[period] ?? 0) + 1;
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.schedule,
                  color: Color(0xFFFFB300),
                  size: 24,
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    AppLocalizations.of(context)!.paymentPeriods,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: periodStats.entries.map((entry) => _buildPeriodChip(
                entry.key,
                entry.value,
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPeriodChip(String period, int count) {
    final periodNames = {
      'daily': 'Dziennie',
      'weekly': 'Tygodniowo',
      'monthly': 'Miesięcznie',
      'yearly': 'Rocznie',
    };
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Color(0xFF29B6F6).withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Color(0xFF29B6F6).withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getPeriodIcon(period),
            color: Color(0xFF29B6F6),
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            '${periodNames[period]} ($count)',
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Color(0xFF29B6F6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMostExpensive(BuildContext context, List<Subscription> subscriptions) {
    final sortedByPrice = List<Subscription>.from(subscriptions)
      ..sort((a, b) => b.cost.compareTo(a.cost));
    
    final topExpensive = sortedByPrice.take(5).toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.trending_up,
                  color: Color(0xFFE53935),
                  size: 24,
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    AppLocalizations.of(context)!.mostExpensiveSubscriptions,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...topExpensive.asMap().entries.map((entry) {
              final index = entry.key;
              final subscription = entry.value;
              return _buildRankingItem(
                index + 1,
                subscription.title,
                '${subscription.cost.toStringAsFixed(2)} ${subscription.currency}',
                subscription.period.getLocalizedDescription(AppLocalizations.of(context)!),
                subscription.iconPath,
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildRankingItem(
    int rank,
    String title,
    String cost,
    String period,
    String iconPath,
  ) {
    Color rankColor;
    if (rank == 1) rankColor = Color(0xFFFFB300);
    else if (rank == 2) rankColor = Color(0xFF9E9E9E);
    else if (rank == 3) rankColor = Color(0xFFAB47BC);
    else rankColor = Color(0xFF757575);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Numer
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: rankColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                rank.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Ikona
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Color(0xFF29B6F6).withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              _getIconForPath(iconPath),
              color: Color(0xFF29B6F6),
              size: 20,
            ),
          ),
          const SizedBox(width: 10),
          // Tytuł i okres - zabierają większość miejsca
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                Text(
                  period,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ),
          ),
          // Koszt - zawsze w tej samej szerokości
          SizedBox(
            width: 90,
            child: Text(
              cost,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.end,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'rozrywka': return Icons.movie;
      case 'muzyka': return Icons.music_note;
      case 'video': return Icons.video_library;
      case 'gry': return Icons.games;
      case 'produktywność': return Icons.work;
      case 'edukacja': return Icons.school;
      case 'sport': return Icons.sports;
      case 'zdrowie': return Icons.health_and_safety;
      case 'finanse': return Icons.account_balance;
      default: return Icons.category;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'rozrywka': return Color(0xFFE53935);  // Error (red)
      case 'muzyka': return Color(0xFFAB47BC);    // Purple
      case 'video': return Color(0xFF29B6F6);     // Secondary (blue)
      case 'gry': return Color(0xFF66BB6A);       // Success (green)
      case 'produktywność': return Color(0xFFFFB300); // Warning (yellow)
      case 'edukacja': return Color(0xFF0288D1);  // Secondary variant
      case 'sport': return Color(0xFFFFA726);     // Primary
      case 'zdrowie': return Color(0xFFFB8C00);   // Primary variant
      case 'finanse': return Color(0xFFFFB300);   // Warning
      default: return Color(0xFF9E9E9E);          // Grey from chart colors
    }
  }

  IconData _getPeriodIcon(String period) {
    switch (period) {
      case 'daily': return Icons.today;
      case 'weekly': return Icons.date_range;
      case 'monthly': return Icons.calendar_month;
      case 'yearly': return Icons.calendar_today;
      default: return Icons.schedule;
    }
  }

  IconData _getIconForPath(String path) {
    if (path.contains('netflix')) return Icons.movie;
    if (path.contains('spotify')) return Icons.music_note;
    if (path.contains('youtube')) return Icons.play_circle;
    if (path.contains('disney')) return Icons.mouse;
    if (path.contains('amazon')) return Icons.shopping_cart;
    if (path.contains('apple')) return Icons.phone_iphone;
    if (path.contains('google')) return Icons.search;
    if (path.contains('microsoft')) return Icons.computer;
    if (path.contains('adobe')) return Icons.design_services;
    return Icons.subscriptions;
  }

  /// Oblicza miesięczny koszt wszystkich subskrypcji
  double _calculateMonthlyCost(List<Subscription> subscriptions) {
    double monthlyTotal = 0.0;
    
    for (final subscription in subscriptions) {
      double monthlyCost = 0.0;
      
      switch (subscription.period.type) {
        case 'daily':
          monthlyCost = subscription.cost * 30 / subscription.period.interval;
          break;
        case 'weekly':
          monthlyCost = subscription.cost * 4.33 / subscription.period.interval;
          break;
        case 'monthly':
          monthlyCost = subscription.cost / subscription.period.interval;
          break;
        case 'yearly':
          monthlyCost = subscription.cost / (12 * subscription.period.interval);
          break;
      }
      
      monthlyTotal += monthlyCost;
    }
    
    return monthlyTotal;
  }

  /// Oblicza roczny koszt wszystkich subskrypcji
  double _calculateYearlyCost(List<Subscription> subscriptions) {
    return _calculateMonthlyCost(subscriptions) * 12;
  }

  /// Zwraca zlokalizowaną nazwę kategorii
  String _getLocalizedCategoryName(BuildContext context, String polishCategory) {
    final localizations = AppLocalizations.of(context)!;
    
    switch (polishCategory) {
      case 'Rozrywka':
        return localizations.categoryEntertainment;
      case 'Muzyka':
        return localizations.categoryMusic;
      case 'Video':
        return localizations.categoryVideo;
      case 'Gry':
        return localizations.categoryGames;
      case 'Produktywność':
        return localizations.categoryProductivity;
      case 'Edukacja':
        return localizations.categoryEducation;
      case 'Sport':
        return localizations.categorySport;
      case 'Zdrowie':
        return localizations.categoryHealth;
      case 'Finanse':
        return localizations.categoryFinance;
      case 'Inne':
        return localizations.categoryOther;
      default:
        return polishCategory; // fallback to original
    }
  }
}
