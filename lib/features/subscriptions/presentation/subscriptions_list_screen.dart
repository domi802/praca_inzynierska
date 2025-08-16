import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../logic/subscriptions_bloc.dart';
import '../../../core/widgets/loading_overlay.dart';

/// Ekran listy subskrypcji - główny ekran aplikacji
class SubscriptionsListScreen extends StatefulWidget {
  const SubscriptionsListScreen({Key? key}) : super(key: key);

  @override
  State<SubscriptionsListScreen> createState() => _SubscriptionsListScreenState();
}

class _SubscriptionsListScreenState extends State<SubscriptionsListScreen> {
  @override
  void initState() {
    super.initState();
    // Załaduj subskrypcje przy pierwszym uruchomieniu
    context.read<SubscriptionsBloc>().add(SubscriptionsLoadRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Moje Subskrypcje'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<SubscriptionsBloc>().add(SubscriptionsRefreshRequested());
            },
          ),
        ],
      ),
      body: BlocListener<SubscriptionsBloc, SubscriptionsState>(
        listener: (context, state) {
          if (state is SubscriptionsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
                action: SnackBarAction(
                  label: 'Spróbuj ponownie',
                  onPressed: () {
                    context.read<SubscriptionsBloc>().add(SubscriptionsLoadRequested());
                  },
                ),
              ),
            );
          }
        },
        child: BlocBuilder<SubscriptionsBloc, SubscriptionsState>(
          builder: (context, state) {
            if (state is SubscriptionsLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is SubscriptionsLoaded) {
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<SubscriptionsBloc>().add(SubscriptionsRefreshRequested());
                },
                child: _buildSubscriptionsList(state),
              );
            }

            if (state is SubscriptionsRefreshing) {
              return LoadingOverlay(
                isLoading: true,
                child: _buildSubscriptionsList(
                  SubscriptionsLoaded(
                    subscriptions: state.subscriptions,
                    totalMonthlyCost: 0,
                    totalYearlyCost: 0,
                  ),
                ),
              );
            }

            if (state is SubscriptionsActionInProgress) {
              return LoadingOverlay(
                isLoading: true,
                loadingText: _getActionText(state.actionType),
                child: _buildSubscriptionsList(
                  SubscriptionsLoaded(
                    subscriptions: state.subscriptions,
                    totalMonthlyCost: 0,
                    totalYearlyCost: 0,
                  ),
                ),
              );
            }

            // Stan początkowy lub błąd
            return _buildEmptyState();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/subscription/add'),
        child: const Icon(Icons.add),
        tooltip: 'Dodaj subskrypcję',
      ),
    );
  }

  Widget _buildSubscriptionsList(SubscriptionsLoaded state) {
    if (state.subscriptions.isEmpty) {
      return _buildEmptyState();
    }

    return CustomScrollView(
      slivers: [
        // Podsumowanie kosztów
        SliverToBoxAdapter(
          child: _buildCostsSummary(state),
        ),
        
        // Lista subskrypcji
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final subscription = state.subscriptions[index];
              return _buildSubscriptionCard(subscription);
            },
            childCount: state.subscriptions.length,
          ),
        ),
      ],
    );
  }

  Widget _buildCostsSummary(SubscriptionsLoaded state) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            'Miesięczny koszt',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${state.totalMonthlyCost.toStringAsFixed(2)} PLN',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    'Roczny koszt',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                  Text(
                    '${state.totalYearlyCost.toStringAsFixed(2)} PLN',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    'Liczba subskrypcji',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                  Text(
                    '${state.subscriptions.length}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionCard(subscription) {
    final daysUntilPayment = subscription.daysUntilNextPayment;
    final isOverdue = subscription.isOverdue;
    final needsReminder = subscription.needsReminder;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: isOverdue 
              ? Colors.red 
              : needsReminder 
                  ? Colors.orange 
                  : Theme.of(context).primaryColor,
          child: Text(
            subscription.title.isNotEmpty 
                ? subscription.title[0].toUpperCase() 
                : 'S',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          subscription.title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text('${subscription.formattedCost} • ${subscription.period.description}'),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  isOverdue 
                      ? Icons.warning 
                      : needsReminder 
                          ? Icons.notification_important 
                          : Icons.schedule,
                  size: 16,
                  color: isOverdue 
                      ? Colors.red 
                      : needsReminder 
                          ? Colors.orange 
                          : Colors.grey,
                ),
                const SizedBox(width: 4),
                Text(
                  isOverdue 
                      ? 'Przeterminowane'
                      : needsReminder 
                          ? 'Płatność jutro'
                          : '$daysUntilPayment dni do płatności',
                  style: TextStyle(
                    color: isOverdue 
                        ? Color(0xFFE53935)
                        : needsReminder 
                            ? Color(0xFFFFB300)
                            : Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'view',
              child: Row(
                children: const [
                  Icon(Icons.visibility),
                  SizedBox(width: 8),
                  Text('Szczegóły'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'edit',
              child: Row(
                children: const [
                  Icon(Icons.edit),
                  SizedBox(width: 8),
                  Text('Edytuj'),
                ],
              ),
            ),
            if (isOverdue || needsReminder)
              PopupMenuItem(
                value: 'paid',
                child: Row(
                  children: const [
                    Icon(Icons.payment),
                    SizedBox(width: 8),
                    Text('Oznacz jako opłacone'),
                  ],
                ),
              ),
            PopupMenuItem(
              value: 'delete',
              child: Row(
                children: const [
                  Icon(Icons.delete, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Usuń', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
          onSelected: (value) => _handleMenuAction(value, subscription),
        ),
        onTap: () => context.go('/subscription/${subscription.id}'),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.subscriptions_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Brak subskrypcji',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Dodaj swoją pierwszą subskrypcję, aby zacząć zarządzać wydatkami',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => context.go('/subscription/add'),
            icon: const Icon(Icons.add),
            label: const Text('Dodaj subskrypcję'),
          ),
        ],
      ),
    );
  }

  void _handleMenuAction(String action, subscription) {
    switch (action) {
      case 'view':
        context.go('/subscription/${subscription.id}');
        break;
      case 'edit':
        context.go('/subscription/${subscription.id}/edit');
        break;
      case 'paid':
        context.read<SubscriptionsBloc>().add(
          SubscriptionMarkAsPaidRequested(subscription.id),
        );
        break;
      case 'delete':
        _showDeleteConfirmation(subscription);
        break;
    }
  }

  void _showDeleteConfirmation(subscription) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Usuń subskrypcję'),
        content: Text(
          'Czy na pewno chcesz usunąć subskrypcję "${subscription.title}"? Tej operacji nie można cofnąć.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Anuluj'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<SubscriptionsBloc>().add(
                SubscriptionDeleteRequested(subscription.id),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Usuń'),
          ),
        ],
      ),
    );
  }

  String _getActionText(String actionType) {
    switch (actionType) {
      case 'add':
        return 'Dodawanie subskrypcji...';
      case 'update':
        return 'Aktualizowanie subskrypcji...';
      case 'delete':
        return 'Usuwanie subskrypcji...';
      case 'mark_paid':
        return 'Oznaczanie jako opłacone...';
      default:
        return 'Przetwarzanie...';
    }
  }
}
