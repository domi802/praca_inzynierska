import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../subscriptions/data/subscription_model.dart';
import '../../subscriptions/logic/subscriptions_bloc.dart';
import '../../../l10n/app_localizations.dart';

/// Ekran kalendarza z terminami płatności
class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Subscription> _getSubscriptionsForPeriod(List<Subscription> allSubscriptions, int days) {
    final now = DateTime.now();
    final endDate = now.add(Duration(days: days));
    
    return allSubscriptions.where((subscription) {
      final nextPayment = subscription.nextPaymentAt;
      return nextPayment.isAfter(now.subtract(const Duration(days: 1))) && 
             nextPayment.isBefore(endDate.add(const Duration(days: 1)));
    }).toList()..sort((a, b) => a.nextPaymentAt.compareTo(b.nextPaymentAt));
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.paymentCalendar),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: localizations.today, icon: const Icon(Icons.today)),
            Tab(text: localizations.thisWeek, icon: const Icon(Icons.date_range)),
            Tab(text: localizations.thisMonth, icon: const Icon(Icons.calendar_month)),
          ],
        ),
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
          
          // Podczas odświeżania zachowaj poprzednie dane
          if (state is SubscriptionsRefreshing) {
            // Używaj poprzednich danych z subskrypcji
            return TabBarView(
              controller: _tabController,
              children: [
                _buildTodayView(state.subscriptions),
                _buildWeekView(state.subscriptions),
                _buildMonthView(state.subscriptions),
              ],
            );
          }
          
          if (state is! SubscriptionsLoaded) {
            return Center(
              child: Text(localizations.noDataToDisplay),
            );
          }

          return TabBarView(
            controller: _tabController,
            children: [
              _buildTodayView(state.subscriptions),
              _buildWeekView(state.subscriptions),
              _buildMonthView(state.subscriptions),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTodayView(List<Subscription> allSubscriptions) {
    final todaySubscriptions = _getSubscriptionsForPeriod(allSubscriptions, 0);
    
    return Column(
      children: [
        // Podsumowanie dzisiejsze
        Card(
          margin: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  AppLocalizations.of(context)!.todaySummary,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildSummaryItem(
                      AppLocalizations.of(context)!.paymentCount,
                      todaySubscriptions.length.toString(),
                      Icons.payment,
                    ),
                    _buildSummaryItem(
                      AppLocalizations.of(context)!.totalCost,
                      '${_calculateTotalCost(todaySubscriptions).toStringAsFixed(2)} PLN',
                      Icons.attach_money,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        // Lista płatności
        Expanded(
          child: _buildSubscriptionsList(
            AppLocalizations.of(context)!.paymentsToday,
            todaySubscriptions,
            Icons.today,
            emptyMessage: AppLocalizations.of(context)!.noPaymentsToday,
            showTotal: false,
          ),
        ),
      ],
    );
  }

  Widget _buildWeekView(List<Subscription> allSubscriptions) {
    final weekSubscriptions = _getSubscriptionsForPeriod(allSubscriptions, 7);
    
    return Column(
      children: [
        // Podsumowanie tygodniowe
        Card(
          margin: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  AppLocalizations.of(context)!.weeklySummary,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildSummaryItem(
                      AppLocalizations.of(context)!.paymentCount,
                      weekSubscriptions.length.toString(),
                      Icons.payment,
                    ),
                    _buildSummaryItem(
                      AppLocalizations.of(context)!.totalCost,
                      '${_calculateTotalCost(weekSubscriptions).toStringAsFixed(2)} PLN',
                      Icons.attach_money,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        // Lista płatności
        Expanded(
          child: _buildSubscriptionsList(
            AppLocalizations.of(context)!.paymentsThisWeek,
            weekSubscriptions,
            Icons.date_range,
            emptyMessage: AppLocalizations.of(context)!.noPaymentsThisWeek,
            showTotal: false,
          ),
        ),
      ],
    );
  }

  Widget _buildMonthView(List<Subscription> allSubscriptions) {
    final monthSubscriptions = _getSubscriptionsForPeriod(allSubscriptions, 30);
    
    return Column(
      children: [
        // Podsumowanie miesięczne
        Card(
          margin: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  AppLocalizations.of(context)!.monthlySummary,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildSummaryItem(
                      AppLocalizations.of(context)!.paymentCount,
                      monthSubscriptions.length.toString(),
                      Icons.payment,
                    ),
                    _buildSummaryItem(
                      AppLocalizations.of(context)!.totalCost,
                      '${_calculateTotalCost(monthSubscriptions).toStringAsFixed(2)} PLN',
                      Icons.attach_money,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        // Lista płatności
        Expanded(
          child: _buildSubscriptionsList(
            AppLocalizations.of(context)!.paymentsThisMonth,
            monthSubscriptions,
            Icons.calendar_month,
            emptyMessage: AppLocalizations.of(context)!.noPaymentsThisMonth,
            showTotal: false,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Theme.of(context).primaryColor, size: 20),
            const SizedBox(width: 4),
            Text(
              value,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSubscriptionsList(
    String title,
    List<Subscription> subscriptions,
    IconData icon, {
    required String emptyMessage,
    bool showTotal = true,
  }) {
    final totalCost = _calculateTotalCost(subscriptions);
    
    return Column(
      children: [
        if (showTotal && subscriptions.isNotEmpty) ...[
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0xFFE3F2FD),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Color(0xFF2196F3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.calculate, color: Color(0xFF1976D2)),
                const SizedBox(width: 12),
                Text(
                  AppLocalizations.of(context)!.totalCostWithCurrency(totalCost.toStringAsFixed(2)),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1976D2),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
        Expanded(
          child: subscriptions.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        icon,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        emptyMessage,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: subscriptions.length,
                  itemBuilder: (context, index) {
                    final subscription = subscriptions[index];
                    return _buildSubscriptionCard(subscription);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildSubscriptionCard(Subscription subscription) {
    final now = DateTime.now();
    final nextPayment = subscription.nextPaymentAt;
    final difference = nextPayment.difference(now).inDays;
    
    Color cardColor;
    Color textColor;
    IconData statusIcon;
    String statusText;
    
    if (difference < 0) {
      cardColor = Color(0xFFFFEBEE);
      textColor = Color(0xFFD32F2F);
      statusIcon = Icons.warning;
      statusText = AppLocalizations.of(context)!.paymentOverdue(-difference);
    } else if (difference == 0) {
      cardColor = Color(0xFFFFF8E1);
      textColor = Color(0xFFF57C00);
      statusIcon = Icons.today;
      statusText = AppLocalizations.of(context)!.today;
    } else if (difference <= 3) {
      cardColor = Color(0xFFFFF3E0);
      textColor = Color(0xFFEF6C00);
      statusIcon = Icons.schedule;
      statusText = AppLocalizations.of(context)!.daysLeft(difference);
    } else {
      cardColor = Color(0xFFE8F5E8);
      textColor = Color(0xFF4CAF50);
      statusIcon = Icons.check_circle_outline;
      statusText = AppLocalizations.of(context)!.daysLeft(difference);
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: cardColor,
      child: InkWell(
        onTap: () {
          context.push('/subscription/${subscription.id}');
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getIconForPath(subscription.iconPath),
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subscription.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          statusIcon,
                          size: 16,
                          color: textColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          statusText,
                          style: TextStyle(
                            color: textColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      AppLocalizations.of(context)!.paymentDate(_formatDate(nextPayment)),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${subscription.cost.toStringAsFixed(2)} ${subscription.currency}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      subscription.period.getLocalizedDescription(AppLocalizations.of(context)!),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              PopupMenuButton<String>(
                onSelected: (value) {
                  switch (value) {
                    case 'mark_paid':
                      context.read<SubscriptionsBloc>().add(
                        SubscriptionMarkAsPaidRequested(subscription.id),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(AppLocalizations.of(context)!.subscriptionMarkedAsPaid),
                          backgroundColor: Color(0xFF66BB6A),
                        ),
                      );
                      break;
                    case 'details':
                      context.push('/subscription/${subscription.id}');
                      break;
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'mark_paid',
                    child: Row(
                      children: [
                        Icon(Icons.payment),
                        SizedBox(width: 8),
                        Text(AppLocalizations.of(context)!.markAsPaid),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'details',
                    child: Row(
                      children: [
                        Icon(Icons.info),
                        SizedBox(width: 8),
                        Text(AppLocalizations.of(context)!.details),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  double _calculateTotalCost(List<Subscription> subscriptions) {
    return subscriptions.fold(0.0, (sum, subscription) => sum + subscription.cost);
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
