import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../subscriptions/data/subscription_model.dart';
import '../../subscriptions/logic/subscriptions_bloc.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kalendarz płatności'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Dzisiaj', icon: Icon(Icons.today)),
            Tab(text: 'Ten tydzień', icon: Icon(Icons.date_range)),
            Tab(text: 'Ten miesiąc', icon: Icon(Icons.calendar_month)),
          ],
        ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/subscription/add');
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTodayView(List<Subscription> allSubscriptions) {
    final todaySubscriptions = _getSubscriptionsForPeriod(allSubscriptions, 0);
    
    return _buildSubscriptionsList(
      'Płatności dzisiaj',
      todaySubscriptions,
      Icons.today,
      emptyMessage: 'Brak płatności na dzisiaj',
    );
  }

  Widget _buildWeekView(List<Subscription> allSubscriptions) {
    final weekSubscriptions = _getSubscriptionsForPeriod(allSubscriptions, 7);
    
    return _buildSubscriptionsList(
      'Płatności w tym tygodniu',
      weekSubscriptions,
      Icons.date_range,
      emptyMessage: 'Brak płatności w tym tygodniu',
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
                  'Podsumowanie miesięczne',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildSummaryItem(
                      'Liczba płatności',
                      monthSubscriptions.length.toString(),
                      Icons.payment,
                    ),
                    _buildSummaryItem(
                      'Łączny koszt',
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
            'Płatności w tym miesiącu',
            monthSubscriptions,
            Icons.calendar_month,
            emptyMessage: 'Brak płatności w tym miesiącu',
            showTotal: false,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Theme.of(context).primaryColor, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.grey[600],
          ),
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
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context).primaryColor.withOpacity(0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.calculate, color: Theme.of(context).primaryColor),
                const SizedBox(width: 12),
                Text(
                  'Łączny koszt: ${totalCost.toStringAsFixed(2)} PLN',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
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
      cardColor = Colors.red.withOpacity(0.1);
      textColor = Colors.red;
      statusIcon = Icons.warning;
      statusText = 'Przeterminowana (${-difference} dni)';
    } else if (difference == 0) {
      cardColor = Colors.orange.withOpacity(0.1);
      textColor = Colors.orange;
      statusIcon = Icons.today;
      statusText = 'Dzisiaj';
    } else if (difference <= 3) {
      cardColor = Colors.amber.withOpacity(0.1);
      textColor = Colors.amber.shade700;
      statusIcon = Icons.schedule;
      statusText = 'Za $difference dni';
    } else {
      cardColor = Colors.green.withOpacity(0.1);
      textColor = Colors.green;
      statusIcon = Icons.check_circle_outline;
      statusText = 'Za $difference dni';
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
                      'Płatność: ${_formatDate(nextPayment)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
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
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    subscription.period.description,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
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
                        const SnackBar(
                          content: Text('Subskrypcja została oznaczona jako opłacona'),
                          backgroundColor: Colors.green,
                        ),
                      );
                      break;
                    case 'details':
                      context.push('/subscription/${subscription.id}');
                      break;
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'mark_paid',
                    child: Row(
                      children: [
                        Icon(Icons.payment),
                        SizedBox(width: 8),
                        Text('Oznacz jako opłacona'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'details',
                    child: Row(
                      children: [
                        Icon(Icons.info),
                        SizedBox(width: 8),
                        Text('Szczegóły'),
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
