import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../data/subscription_model.dart';
import '../logic/subscriptions_bloc.dart';
import '../../../core/services/logger_service.dart';

/// Ekran szczegółów subskrypcji
class SubscriptionDetailScreen extends StatefulWidget {
  final String subscriptionId;

  const SubscriptionDetailScreen({
    Key? key,
    required this.subscriptionId,
  }) : super(key: key);

  @override
  State<SubscriptionDetailScreen> createState() => _SubscriptionDetailScreenState();
}

class _SubscriptionDetailScreenState extends State<SubscriptionDetailScreen> {
  Subscription? _subscription;

  @override
  void initState() {
    super.initState();
    _loadSubscription();
  }

  void _loadSubscription() {
    final state = context.read<SubscriptionsBloc>().state;
    if (state is SubscriptionsLoaded) {
      try {
        _subscription = state.subscriptions.firstWhere(
          (sub) => sub.id == widget.subscriptionId,
        );
      } catch (e) {
        LoggerService.info('Subskrypcja nie znaleziona: ${widget.subscriptionId}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_subscription?.title ?? 'Szczegóły subskrypcji'),
        actions: [
          if (_subscription != null) ...[
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                context.push('/subscription/${widget.subscriptionId}/edit');
              },
            ),
            PopupMenuButton<String>(
              onSelected: (value) {
                switch (value) {
                  case 'mark_paid':
                    _markAsPaid();
                    break;
                  case 'delete':
                    _showDeleteDialog();
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
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Usuń subskrypcję', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
      body: BlocListener<SubscriptionsBloc, SubscriptionsState>(
        listener: (context, state) {
          if (state is SubscriptionsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is SubscriptionsLoaded) {
            // Aktualizuj dane subskrypcji
            setState(() {
              try {
                _subscription = state.subscriptions.firstWhere(
                  (sub) => sub.id == widget.subscriptionId,
                );
              } catch (e) {
                // Subskrypcja została usunięta, wróć do listy
                context.pop();
              }
            });
          }
        },
        child: _subscription == null
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 16),
                    Text('Subskrypcja nie została znaleziona'),
                  ],
                ),
              )
            : _buildSubscriptionDetails(),
      ),
    );
  }

  Widget _buildSubscriptionDetails() {
    final subscription = _subscription!;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Karta główna z podstawowymi informacjami
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          _getIconForPath(subscription.iconPath),
                          size: 30,
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
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (subscription.category != null) ...[
                              const SizedBox(height: 4),
                              Chip(
                                label: Text(
                                  subscription.category!,
                                  style: const TextStyle(fontSize: 12),
                                ),
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildInfoColumn(
                        'Koszt',
                        '${subscription.cost.toStringAsFixed(2)} ${subscription.currency}',
                        Icons.attach_money,
                      ),
                      _buildInfoColumn(
                        'Okres',
                        subscription.period.description,
                        Icons.schedule,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Daty płatności
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Daty płatności',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildDateInfo(
                    'Ostatnia płatność',
                    subscription.lastPaidAt,
                    Icons.check_circle,
                    Colors.green,
                  ),
                  const SizedBox(height: 12),
                  _buildDateInfo(
                    'Następna płatność',
                    subscription.nextPaymentAt,
                    Icons.schedule,
                    _getNextPaymentColor(subscription.nextPaymentAt),
                  ),
                  const SizedBox(height: 16),
                  _buildDaysUntilPayment(subscription.nextPaymentAt),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Dodatkowe informacje
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Dodatkowe informacje',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow(
                    'Powiadomienia',
                    subscription.notify ? 'Włączone' : 'Wyłączone',
                    subscription.notify ? Icons.notifications_active : Icons.notifications_off,
                  ),
                  _buildInfoRow(
                    'Przypomnienie',
                    '${subscription.reminderDays} dni przed',
                    Icons.alarm,
                  ),
                  _buildInfoRow(
                    'Data utworzenia',
                    _formatDate(subscription.createdAt),
                    Icons.calendar_today,
                  ),
                  if (subscription.notes != null && subscription.notes!.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    const Divider(),
                    const SizedBox(height: 12),
                    Text(
                      'Notatki',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      subscription.notes!,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Przyciski akcji
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _markAsPaid,
                  icon: const Icon(Icons.payment),
                  label: const Text('Oznacz jako opłacona'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                onPressed: _showDeleteDialog,
                icon: const Icon(Icons.delete),
                label: const Text('Usuń'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoColumn(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Theme.of(context).primaryColor),
        const SizedBox(height: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildDateInfo(String label, DateTime date, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            Text(
              _formatDate(date),
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDaysUntilPayment(DateTime nextPayment) {
    final now = DateTime.now();
    final difference = nextPayment.difference(now).inDays;
    
    String text;
    Color color;
    
    if (difference < 0) {
      text = 'Płatność przeterminowana (${(-difference)} dni)';
      color = Colors.red;
    } else if (difference == 0) {
      text = 'Płatność dzisiaj';
      color = Colors.orange;
    } else if (difference <= 3) {
      text = 'Płatność za $difference dni';
      color = Colors.orange;
    } else {
      text = 'Płatność za $difference dni';
      color = Colors.green;
    }
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.access_time, color: color, size: 20),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
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

  Color _getNextPaymentColor(DateTime nextPayment) {
    final difference = nextPayment.difference(DateTime.now()).inDays;
    if (difference < 0) return Colors.red;
    if (difference <= 3) return Colors.orange;
    return Colors.green;
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }

  void _markAsPaid() {
    context.read<SubscriptionsBloc>().add(
      SubscriptionMarkAsPaidRequested(widget.subscriptionId),
    );
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Subskrypcja została oznaczona jako opłacona'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Usuń subskrypcję'),
        content: Text('Czy na pewno chcesz usunąć subskrypcję "${_subscription?.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Anuluj'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<SubscriptionsBloc>().add(
                SubscriptionDeleteRequested(widget.subscriptionId),
              );
              context.pop(); // Wróć do listy
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Subskrypcja została usunięta'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Usuń'),
          ),
        ],
      ),
    );
  }
}
