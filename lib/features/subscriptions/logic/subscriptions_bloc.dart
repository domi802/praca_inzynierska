import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../data/subscription_model.dart';
import '../data/subscription_repository.dart';
import '../../../core/services/logger_service.dart';

// Events
abstract class SubscriptionsEvent extends Equatable {
  const SubscriptionsEvent();
  
  @override
  List<Object?> get props => [];
}

class SubscriptionsLoadRequested extends SubscriptionsEvent {}

class SubscriptionsRefreshRequested extends SubscriptionsEvent {}

class SubscriptionAddRequested extends SubscriptionsEvent {
  final Subscription subscription;
  
  const SubscriptionAddRequested(this.subscription);
  
  @override
  List<Object?> get props => [subscription];
}

class SubscriptionUpdateRequested extends SubscriptionsEvent {
  final Subscription subscription;
  
  const SubscriptionUpdateRequested(this.subscription);
  
  @override
  List<Object?> get props => [subscription];
}

class SubscriptionDeleteRequested extends SubscriptionsEvent {
  final String subscriptionId;
  
  const SubscriptionDeleteRequested(this.subscriptionId);
  
  @override
  List<Object?> get props => [subscriptionId];
}

class SubscriptionMarkAsPaidRequested extends SubscriptionsEvent {
  final String subscriptionId;
  
  const SubscriptionMarkAsPaidRequested(this.subscriptionId);
  
  @override
  List<Object?> get props => [subscriptionId];
}

// States
abstract class SubscriptionsState extends Equatable {
  const SubscriptionsState();
  
  @override
  List<Object?> get props => [];
}

class SubscriptionsInitial extends SubscriptionsState {}

class SubscriptionsLoading extends SubscriptionsState {}

class SubscriptionsRefreshing extends SubscriptionsState {
  final List<Subscription> subscriptions;
  
  const SubscriptionsRefreshing(this.subscriptions);
  
  @override
  List<Object?> get props => [subscriptions];
}

class SubscriptionsLoaded extends SubscriptionsState {
  final List<Subscription> subscriptions;
  final double totalMonthlyCost;
  final double totalYearlyCost;
  
  const SubscriptionsLoaded({
    required this.subscriptions,
    required this.totalMonthlyCost,
    required this.totalYearlyCost,
  });
  
  @override
  List<Object?> get props => [subscriptions, totalMonthlyCost, totalYearlyCost];
}

class SubscriptionsError extends SubscriptionsState {
  final String message;
  
  const SubscriptionsError(this.message);
  
  @override
  List<Object?> get props => [message];
}

class SubscriptionsActionInProgress extends SubscriptionsState {
  final List<Subscription> subscriptions;
  final String actionType;
  
  const SubscriptionsActionInProgress({
    required this.subscriptions,
    required this.actionType,
  });
  
  @override
  List<Object?> get props => [subscriptions, actionType];
}

// BLoC
class SubscriptionsBloc extends Bloc<SubscriptionsEvent, SubscriptionsState> {
  final SubscriptionRepository _subscriptionRepository;
  
  SubscriptionsBloc({SubscriptionRepository? subscriptionRepository})
      : _subscriptionRepository = subscriptionRepository ?? SubscriptionRepository(),
        super(SubscriptionsInitial()) {
    
    on<SubscriptionsLoadRequested>(_onSubscriptionsLoadRequested);
    on<SubscriptionsRefreshRequested>(_onSubscriptionsRefreshRequested);
    on<SubscriptionAddRequested>(_onSubscriptionAddRequested);
    on<SubscriptionUpdateRequested>(_onSubscriptionUpdateRequested);
    on<SubscriptionDeleteRequested>(_onSubscriptionDeleteRequested);
    on<SubscriptionMarkAsPaidRequested>(_onSubscriptionMarkAsPaidRequested);
  }

  Future<void> _onSubscriptionsLoadRequested(
    SubscriptionsLoadRequested event,
    Emitter<SubscriptionsState> emit,
  ) async {
    if (state is! SubscriptionsLoaded) {
      emit(SubscriptionsLoading());
    }
    
    try {
      final subscriptions = await _subscriptionRepository.getSubscriptions();
      final costs = _calculateCosts(subscriptions);
      
      emit(SubscriptionsLoaded(
        subscriptions: subscriptions,
        totalMonthlyCost: costs['monthly']!,
        totalYearlyCost: costs['yearly']!,
      ));
    } catch (e) {
      LoggerService.error('Błąd podczas ładowania subskrypcji', e);
      emit(SubscriptionsError(_getErrorMessage(e)));
    }
  }

  Future<void> _onSubscriptionsRefreshRequested(
    SubscriptionsRefreshRequested event,
    Emitter<SubscriptionsState> emit,
  ) async {
    final currentState = state;
    
    if (currentState is SubscriptionsLoaded) {
      emit(SubscriptionsRefreshing(currentState.subscriptions));
    }
    
    try {
      final subscriptions = await _subscriptionRepository.getSubscriptions();
      final costs = _calculateCosts(subscriptions);
      
      emit(SubscriptionsLoaded(
        subscriptions: subscriptions,
        totalMonthlyCost: costs['monthly']!,
        totalYearlyCost: costs['yearly']!,
      ));
    } catch (e) {
      LoggerService.error('Błąd podczas odświeżania subskrypcji', e);
      if (currentState is SubscriptionsLoaded) {
        emit(currentState);
      } else {
        emit(SubscriptionsError(_getErrorMessage(e)));
      }
    }
  }

  Future<void> _onSubscriptionAddRequested(
    SubscriptionAddRequested event,
    Emitter<SubscriptionsState> emit,
  ) async {
    final currentState = state;
    
    if (currentState is SubscriptionsLoaded) {
      emit(SubscriptionsActionInProgress(
        subscriptions: currentState.subscriptions,
        actionType: 'add',
      ));
    }
    
    try {
      await _subscriptionRepository.addSubscription(event.subscription);
      add(SubscriptionsLoadRequested());
      LoggerService.info('Dodano nową subskrypcję: ${event.subscription.title}');
    } catch (e) {
      LoggerService.error('Błąd podczas dodawania subskrypcji', e);
      if (currentState is SubscriptionsLoaded) {
        emit(currentState);
      }
      emit(SubscriptionsError(_getErrorMessage(e)));
    }
  }

  Future<void> _onSubscriptionUpdateRequested(
    SubscriptionUpdateRequested event,
    Emitter<SubscriptionsState> emit,
  ) async {
    final currentState = state;
    
    if (currentState is SubscriptionsLoaded) {
      emit(SubscriptionsActionInProgress(
        subscriptions: currentState.subscriptions,
        actionType: 'update',
      ));
    }
    
    try {
      await _subscriptionRepository.updateSubscription(event.subscription);
      add(SubscriptionsLoadRequested());
      LoggerService.info('Zaktualizowano subskrypcję: ${event.subscription.title}');
    } catch (e) {
      LoggerService.error('Błąd podczas aktualizacji subskrypcji', e);
      if (currentState is SubscriptionsLoaded) {
        emit(currentState);
      }
      emit(SubscriptionsError(_getErrorMessage(e)));
    }
  }

  Future<void> _onSubscriptionDeleteRequested(
    SubscriptionDeleteRequested event,
    Emitter<SubscriptionsState> emit,
  ) async {
    final currentState = state;
    
    if (currentState is SubscriptionsLoaded) {
      emit(SubscriptionsActionInProgress(
        subscriptions: currentState.subscriptions,
        actionType: 'delete',
      ));
    }
    
    try {
      await _subscriptionRepository.deleteSubscription(event.subscriptionId);
      add(SubscriptionsLoadRequested());
      LoggerService.info('Usunięto subskrypcję: ${event.subscriptionId}');
    } catch (e) {
      LoggerService.error('Błąd podczas usuwania subskrypcji', e);
      if (currentState is SubscriptionsLoaded) {
        emit(currentState);
      }
      emit(SubscriptionsError(_getErrorMessage(e)));
    }
  }

  Future<void> _onSubscriptionMarkAsPaidRequested(
    SubscriptionMarkAsPaidRequested event,
    Emitter<SubscriptionsState> emit,
  ) async {
    final currentState = state;
    
    if (currentState is SubscriptionsLoaded) {
      emit(SubscriptionsActionInProgress(
        subscriptions: currentState.subscriptions,
        actionType: 'mark_paid',
      ));
    }
    
    try {
      await _subscriptionRepository.markSubscriptionAsPaid(event.subscriptionId);
      add(SubscriptionsLoadRequested());
      LoggerService.info('Oznaczono subskrypcję jako opłaconą: ${event.subscriptionId}');
    } catch (e) {
      LoggerService.error('Błąd podczas oznaczania subskrypcji jako opłaconej', e);
      if (currentState is SubscriptionsLoaded) {
        emit(currentState);
      }
      emit(SubscriptionsError(_getErrorMessage(e)));
    }
  }

  /// Oblicza całkowite koszty miesięczne i roczne
  Map<String, double> _calculateCosts(List<Subscription> subscriptions) {
    double monthlyTotal = 0.0;
    double yearlyTotal = 0.0;
    
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
      yearlyTotal += monthlyCost * 12;
    }
    
    return {
      'monthly': monthlyTotal,
      'yearly': yearlyTotal,
    };
  }

  String _getErrorMessage(dynamic error) {
    if (error is Exception) {
      return error.toString().replaceFirst('Exception: ', '');
    }
    return 'Wystąpił nieoczekiwany błąd';
  }
}
