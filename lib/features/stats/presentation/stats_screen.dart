import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../subscriptions/data/subscription_model.dart';
import '../../subscriptions/logic/subscriptions_bloc.dart';

/// Ekran statystyk wydatków
class StatsScreen extends StatelessWidget {
  const StatsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statystyki'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<SubscriptionsBloc>().add(SubscriptionsRefreshRequested());
            },
          ),
        ],
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
                  const Icon(Icons.error, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Błąd: ${state.message}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<SubscriptionsBloc>().add(SubscriptionsLoadRequested());
                    },
                    child: const Text('Spróbuj ponownie'),
                  ),
                ],
              ),
            );
          }
          
          if (state is! SubscriptionsLoaded) {
            return const Center(
              child: Text('Brak danych do wyświetlenia'),
            );
          }

          if (state.subscriptions.isEmpty) {
            return const Center(
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
                    'Brak subskrypcji',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Dodaj subskrypcje, aby zobaczyć statystyki',
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
                _buildCostSummary(state),
                const SizedBox(height: 20),
                
                // Statystyki według kategorii
                _buildCategoryStats(state.subscriptions),
                const SizedBox(height: 20),
                
                // Statystyki według okresu
                _buildPeriodStats(state.subscriptions),
                const SizedBox(height: 20),
                
                // Najbardziej kosztowne subskrypcje
                _buildMostExpensive(state.subscriptions),
                const SizedBox(height: 20),
                
                // Nadchodzące płatności
                _buildUpcomingPayments(state.subscriptions),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCostSummary(SubscriptionsLoaded state) {
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
                  color: Colors.green,
                  size: 28,
                ),
                const SizedBox(width: 12),
                const Text(
                  'Podsumowanie kosztów',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _buildCostCard(
                    'Miesięcznie',
                    '${state.totalMonthlyCost.toStringAsFixed(2)} PLN',
                    Icons.calendar_month,
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildCostCard(
                    'Rocznie',
                    '${state.totalYearlyCost.toStringAsFixed(2)} PLN',
                    Icons.calendar_today,
                    Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange.withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  const Icon(Icons.savings, color: Colors.orange, size: 24),
                  const SizedBox(height: 8),
                  const Text(
                    'Średnia koszt na subskrypcję',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.orange,
                    ),
                  ),
                  Text(
                    '${(state.totalMonthlyCost / state.subscriptions.length).toStringAsFixed(2)} PLN/miesiąc',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                ],
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
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryStats(List<Subscription> subscriptions) {
    final categoryStats = <String, double>{};
    final categoryCounts = <String, int>{};
    
    for (final subscription in subscriptions) {
      final category = subscription.category ?? 'Inne';
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
                  color: Colors.purple,
                  size: 28,
                ),
                const SizedBox(width: 12),
                const Text(
                  'Wydatki według kategorii',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...sortedCategories.map((entry) => _buildCategoryItem(
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

  Widget _buildCategoryItem(String category, double amount, int count, double total) {
    final percentage = (amount / total * 100);
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      _getCategoryIcon(category),
                      size: 20,
                      color: _getCategoryColor(category),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      category,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        count.toString(),
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${amount.toStringAsFixed(2)} PLN',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
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

  Widget _buildPeriodStats(List<Subscription> subscriptions) {
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
                  color: Colors.orange,
                  size: 28,
                ),
                const SizedBox(width: 12),
                const Text(
                  'Rozkład okresów płatności',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
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
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.blue.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getPeriodIcon(period),
            color: Colors.blue,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            '${periodNames[period]} ($count)',
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMostExpensive(List<Subscription> subscriptions) {
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
                  color: Colors.red,
                  size: 28,
                ),
                const SizedBox(width: 12),
                const Text(
                  'Najkosztowniejsze subskrypcje',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
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
                subscription.period.description,
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
    if (rank == 1) rankColor = Colors.amber;
    else if (rank == 2) rankColor = Colors.grey;
    else if (rank == 3) rankColor = Colors.brown;
    else rankColor = Colors.grey.shade400;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
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
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getIconForPath(iconPath),
              color: Colors.blue,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  period,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            cost,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingPayments(List<Subscription> subscriptions) {
    final now = DateTime.now();
    final upcoming = subscriptions.where((sub) {
      final daysUntil = sub.nextPaymentAt.difference(now).inDays;
      return daysUntil >= 0 && daysUntil <= 7;
    }).toList()..sort((a, b) => a.nextPaymentAt.compareTo(b.nextPaymentAt));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.upcoming,
                  color: Colors.green,
                  size: 28,
                ),
                const SizedBox(width: 12),
                const Text(
                  'Nadchodzące płatności (7 dni)',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (upcoming.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    'Brak płatności w ciągu najbliższych 7 dni',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                ),
              )
            else
              ...upcoming.map((subscription) => _buildUpcomingPaymentItem(subscription)),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingPaymentItem(Subscription subscription) {
    final daysUntil = subscription.nextPaymentAt.difference(DateTime.now()).inDays;
    
    String timeText;
    Color timeColor;
    
    if (daysUntil == 0) {
      timeText = 'Dzisiaj';
      timeColor = Colors.red;
    } else if (daysUntil == 1) {
      timeText = 'Jutro';
      timeColor = Colors.orange;
    } else {
      timeText = 'Za $daysUntil dni';
      timeColor = Colors.green;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getIconForPath(subscription.iconPath),
              color: Colors.blue,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subscription.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  _formatDate(subscription.nextPaymentAt),
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${subscription.cost.toStringAsFixed(2)} ${subscription.currency}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: timeColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  timeText,
                  style: TextStyle(
                    color: timeColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
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
      case 'rozrywka': return Colors.red;
      case 'muzyka': return Colors.purple;
      case 'video': return Colors.blue;
      case 'gry': return Colors.green;
      case 'produktywność': return Colors.orange;
      case 'edukacja': return Colors.indigo;
      case 'sport': return Colors.teal;
      case 'zdrowie': return Colors.pink;
      case 'finanse': return Colors.amber;
      default: return Colors.grey;
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

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }
}
