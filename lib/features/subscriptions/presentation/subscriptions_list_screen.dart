import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../l10n/app_localizations.dart';

import '../logic/subscriptions_bloc.dart';
import '../data/subscription_model.dart';
import '../../../core/widgets/loading_overlay.dart';
import '../../auth/logic/auth_bloc.dart';

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
    // Załaduj subskrypcje tylko jeśli nie są już załadowane
    final currentState = context.read<SubscriptionsBloc>().state;
    if (currentState is! SubscriptionsLoaded) {
      context.read<SubscriptionsBloc>().add(SubscriptionsLoadRequested());
    }
  }

  String _getPaymentStatusText(BuildContext context, Subscription subscription) {
    final localizations = AppLocalizations.of(context)!;
    
    if (subscription.isOverdue) {
      return localizations.overdue;
    } else if (subscription.daysUntilNextPayment == 0) {
      return localizations.paymentToday;
    } else if (subscription.daysUntilNextPayment == 1) {
      return localizations.paymentTomorrow;
    } else if (subscription.needsReminder) {
      return localizations.paymentTomorrow;
    } else {
      return localizations.daysShort(subscription.daysUntilNextPayment);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, authState) {
            if (authState is AuthAuthenticated) {
              return Align(
                alignment: Alignment.centerLeft,
                child: Text(AppLocalizations.of(context)!.welcomeUser(authState.user.firstName)),
              );
            }
            return Text(AppLocalizations.of(context)!.subscriptionTitle);
          },
        ),
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<AuthBloc, AuthState>(
            listener: (context, authState) {
              if (authState is AuthUnauthenticated) {
                // Wyczyść stan subskrypcji gdy użytkownik się wyloguje
                context.read<SubscriptionsBloc>().add(SubscriptionsClearRequested());
              } else if (authState is AuthAuthenticated) {
                // Załaduj subskrypcje dla nowego użytkownika
                context.read<SubscriptionsBloc>().add(SubscriptionsLoadRequested());
              }
            },
          ),
          BlocListener<SubscriptionsBloc, SubscriptionsState>(
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
          ),
        ],
        child: BlocBuilder<SubscriptionsBloc, SubscriptionsState>(
          builder: (context, state) {
            if (state is SubscriptionsLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is SubscriptionsLoaded) {
              return _buildSubscriptionsList(state);
            }

            if (state is SubscriptionsRefreshing) {
              return LoadingOverlay(
                isLoading: true,
                child: _buildSubscriptionsList(
                  SubscriptionsLoaded(
                    subscriptions: state.subscriptions,
                    totalMonthlyCost: 0.0, // Tymczasowe wartości, nie są używane
                    totalYearlyCost: 0.0,
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
                    totalMonthlyCost: 0.0, // Tymczasowe wartości, nie są używane
                    totalYearlyCost: 0.0,
                  ),
                ),
              );
            }

            // Stan początkowy lub błąd
            return _buildEmptyState();
          },
        ),
      ),
    );
  }

  Widget _buildSubscriptionsList(SubscriptionsLoaded state) {
    if (state.subscriptions.isEmpty) {
      return _buildEmptyState();
    }

    // Filtruj nadchodzące płatności (w ciągu 3 dni) lub przeterminowane
    final upcomingPayments = state.subscriptions.where((subscription) {
      final daysUntilPayment = subscription.daysUntilNextPayment;
      return daysUntilPayment <= 3 || subscription.isOverdue;
    }).toList();

    return CustomScrollView(
      slivers: [
        // Nadchodzące płatności
        SliverToBoxAdapter(
          child: _buildUpcomingPayments(upcomingPayments),
        ),
        
        // Wszystkie subskrypcje
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
            child: Text(
              AppLocalizations.of(context)!.allSubscriptions,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
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

  Widget _buildUpcomingPayments(List<Subscription> upcomingPayments) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              AppLocalizations.of(context)!.upcomingPayments,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 12),
          if (upcomingPayments.isEmpty)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.green.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    color: Colors.green,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context)!.allCurrentSubscriptionsPaid,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.green[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            )
          else
            SizedBox(
              height: 130,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: upcomingPayments.length,
                itemBuilder: (context, index) {
                  final subscription = upcomingPayments[index];
                  return _buildPaymentPill(subscription);
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPaymentPill(Subscription subscription) {
    final isOverdue = subscription.isOverdue;
    final needsReminder = subscription.needsReminder;
    
    Color cardColor;
    Color textColor;
    Color iconColor;
    String timeText;
    
    if (isOverdue) {
      cardColor = Colors.red[50]!;
      textColor = Colors.red[700]!;
      iconColor = Colors.red;
      timeText = AppLocalizations.of(context)!.overdue;
    } else if (needsReminder) {
      cardColor = Colors.orange[50]!;
      textColor = Colors.orange[700]!;
      iconColor = Colors.orange;
      timeText = subscription.daysUntilNextPayment == 0 
          ? AppLocalizations.of(context)!.paymentToday 
          : AppLocalizations.of(context)!.paymentTomorrow;
    } else {
      cardColor = Colors.blue[50]!;
      textColor = Colors.blue[700]!;
      iconColor = Colors.blue;
      timeText = AppLocalizations.of(context)!.daysShort(subscription.daysUntilNextPayment);
    }
    
    return GestureDetector(
      onTap: () => _showPaymentDetails(subscription),
      child: Container(
        width: 170,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: iconColor.withOpacity(0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Icon(
                      _getIconForPath(subscription.iconPath),
                      color: iconColor,
                      size: 24,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  subscription.formattedCost,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              subscription.title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: textColor,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              timeText,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: textColor.withOpacity(0.7),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPaymentDetails(Subscription subscription) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.7,
          ),
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                      child: Icon(
                        _getIconForPath(subscription.iconPath),
                        color: Theme.of(context).primaryColor,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            subscription.title,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            subscription.formattedCost,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _buildDetailRow(
                  Icons.schedule,
                  AppLocalizations.of(context)!.nextPayment,
                  _getPaymentStatusText(context, subscription),
                ),
                const SizedBox(height: 16),
                _buildDetailRow(
                  Icons.calendar_today,
                  AppLocalizations.of(context)!.paymentDateLabel,
                  '${subscription.nextPaymentAt.day}.${subscription.nextPaymentAt.month.toString().padLeft(2, '0')}.${subscription.nextPaymentAt.year}',
                ),
                const SizedBox(height: 16),
                _buildDetailRow(
                  Icons.repeat,
                  AppLocalizations.of(context)!.paymentPeriod,
                  subscription.period.getLocalizedDescription(AppLocalizations.of(context)!),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          context.go('/subscription/${subscription.id}');
                        },
                        child: Text(AppLocalizations.of(context)!.details),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          context.read<SubscriptionsBloc>().add(
                            SubscriptionMarkAsPaidRequested(subscription.id),
                          );
                        },
                        child: Text(AppLocalizations.of(context)!.markAsPaid),
                      ),
                    ),
                  ],
                ),
                // Dodanie dodatkowego miejsca na dole dla bezpieczeństwa
                SizedBox(height: MediaQuery.of(context).viewInsets.bottom > 0 ? 20 : 0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: Colors.grey[600],
        ),
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
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildSubscriptionCard(subscription) {
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
          child: Icon(
            _getIconForPath(subscription.iconPath),
            color: Colors.white,
            size: 20,
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
            Text('${subscription.formattedCost} • ${subscription.period.getLocalizedDescription(AppLocalizations.of(context)!)}'),
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
                  _getPaymentStatusText(context, subscription),
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
                children: [
                  Icon(Icons.visibility),
                  SizedBox(width: 8),
                  Text(AppLocalizations.of(context)!.viewMenuItem),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit),
                  SizedBox(width: 8),
                  Text(AppLocalizations.of(context)!.editMenuItem),
                ],
              ),
            ),
            if (isOverdue || needsReminder)
              PopupMenuItem(
                value: 'paid',
                child: Row(
                  children: [
                    Icon(Icons.payment),
                    SizedBox(width: 8),
                    Text(AppLocalizations.of(context)!.markAsPaidMenuItem),
                  ],
                ),
              ),
            PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, color: Colors.red),
                  SizedBox(width: 8),
                  Text(AppLocalizations.of(context)!.deleteMenuItem, style: TextStyle(color: Colors.red)),
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
    final localizations = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(localizations.deleteSubscription),
        content: Text(
          localizations.confirmDeleteSubscription(subscription.title),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(localizations.cancel),
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
            child: Text(localizations.delete),
          ),
        ],
      ),
    );
  }

  String _getActionText(String actionType) {
    final localizations = AppLocalizations.of(context)!;
    switch (actionType) {
      case 'add':
        return localizations.loadingUpdatingSubscription; // Adding will use same text as updating
      case 'update':
        return localizations.loadingUpdatingSubscription;
      case 'delete':
        return localizations.loadingDeletingSubscription;
      case 'mark_paid':
        return localizations.loadingMarkingAsPaid;
      default:
        return localizations.loadingProcessing;
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
}
