import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../data/subscription_model.dart';
import '../logic/subscriptions_bloc.dart';
import '../../auth/logic/auth_bloc.dart';
import '../../../core/services/logger_service.dart';

/// Ekran dodawania/edycji subskrypcji
class AddEditSubscriptionScreen extends StatefulWidget {
  final String? subscriptionId;

  const AddEditSubscriptionScreen({
    Key? key,
    this.subscriptionId,
  }) : super(key: key);

  @override
  State<AddEditSubscriptionScreen> createState() => _AddEditSubscriptionScreenState();
}

class _AddEditSubscriptionScreenState extends State<AddEditSubscriptionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _costController = TextEditingController();
  final _notesController = TextEditingController();
  
  String _selectedCategory = 'Rozrywka';
  String _selectedPeriodType = 'monthly';
  int _periodInterval = 1;
  DateTime _nextPaymentDate = DateTime.now().add(const Duration(days: 30));
  String _selectedIcon = 'subscription_icons/default.png';
  
  bool get isEditing => widget.subscriptionId != null;
  
  final List<String> _categories = [
    'Rozrywka',
    'Muzyka',
    'Video',
    'Gry',
    'Produktywność',
    'Edukacja',
    'Sport',
    'Zdrowie',
    'Finanse',
    'Inne',
  ];
  
  final Map<String, String> _periodTypes = {
    'daily': 'Dziennie',
    'weekly': 'Tygodniowo', 
    'monthly': 'Miesięcznie',
    'yearly': 'Rocznie',
  };
  
  final Map<String, String> _iconOptions = {
    'subscription_icons/netflix.png': 'Netflix',
    'subscription_icons/spotify.png': 'Spotify',
    'subscription_icons/youtube.png': 'YouTube',
    'subscription_icons/disney.png': 'Disney+',
    'subscription_icons/amazon.png': 'Amazon Prime',
    'subscription_icons/apple.png': 'Apple',
    'subscription_icons/google.png': 'Google',
    'subscription_icons/microsoft.png': 'Microsoft',
    'subscription_icons/adobe.png': 'Adobe',
    'subscription_icons/default.png': 'Domyślna',
  };

  @override
  void dispose() {
    _titleController.dispose();
    _costController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edytuj subskrypcję' : 'Dodaj subskrypcję'),
        actions: [
          BlocBuilder<SubscriptionsBloc, SubscriptionsState>(
            builder: (context, state) {
              final isLoading = state is SubscriptionsLoading;
              return isLoading 
                ? const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : IconButton(
                    icon: const Icon(Icons.save),
                    onPressed: _saveSubscription,
                  );
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
              ),
            );
          } else if (state is SubscriptionsLoaded) {
            // Przejdź do ekranu głównego po zapisaniu
            context.go('/');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  isEditing 
                    ? 'Subskrypcja została zaktualizowana' 
                    : 'Subskrypcja została dodana',
                  style: const TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 3),
              ),
            );
          }
        },
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Ikona subskrypcji
              _buildIconSelector(),
              const SizedBox(height: 24),
              
              // Nazwa subskrypcji
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nazwa subskrypcji',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _titleController,
                        decoration: const InputDecoration(
                          hintText: 'np. Netflix, Spotify...',
                          prefixIcon: Icon(Icons.subscriptions),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Podaj nazwę subskrypcji';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // Kategoria
              _buildCategorySelector(),
              const SizedBox(height: 16),
              
              // Koszt
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Koszt (PLN)',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _costController,
                        decoration: const InputDecoration(
                          hintText: '0.00',
                          prefixIcon: Icon(Icons.attach_money),
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Podaj koszt';
                          }
                          final cost = double.tryParse(value.replaceAll(',', '.'));
                          if (cost == null || cost <= 0) {
                            return 'Podaj prawidłowy koszt';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // Okres płatności
              _buildPeriodSelector(),
              const SizedBox(height: 16),
              
              // Data następnej płatności
              _buildNextPaymentDatePicker(),
              const SizedBox(height: 16),
              
              // Notatki
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Notatki (opcjonalnie)',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _notesController,
                        decoration: const InputDecoration(
                          hintText: 'Dodatkowe informacje...',
                          prefixIcon: Icon(Icons.note),
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              
              // Przycisk zapisz
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _saveSubscription,
                  child: Text(
                    isEditing ? 'Zaktualizuj subskrypcję' : 'Dodaj subskrypcję',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconSelector() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ikona subskrypcji',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Container(
              height: 80,
              width: double.infinity,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _iconOptions.length,
                itemBuilder: (context, index) {
                  final iconPath = _iconOptions.keys.elementAt(index);
                  final iconName = _iconOptions[iconPath]!;
                  final isSelected = _selectedIcon == iconPath;
                  
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedIcon = iconPath;
                        });
                      },
                      child: Container(
                        width: 60,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isSelected ? Theme.of(context).primaryColor : Colors.grey.shade300,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _getIconForPath(iconPath),
                              size: 24,
                              color: isSelected ? Theme.of(context).primaryColor : Colors.grey,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              iconName,
                              style: TextStyle(
                                fontSize: 10,
                                color: isSelected ? Theme.of(context).primaryColor : Colors.grey,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
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

  Widget _buildCategorySelector() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Kategoria',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.category),
                border: OutlineInputBorder(),
              ),
              items: _categories.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedCategory = value;
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPeriodSelector() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Okres płatności',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: DropdownButtonFormField<String>(
                    value: _selectedPeriodType,
                    decoration: const InputDecoration(
                      labelText: 'Typ',
                      border: OutlineInputBorder(),
                    ),
                    items: _periodTypes.entries.map((entry) {
                      return DropdownMenuItem(
                        value: entry.key,
                        child: Text(entry.value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedPeriodType = value;
                          _updateNextPaymentDate();
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 1,
                  child: TextFormField(
                    initialValue: _periodInterval.toString(),
                    decoration: const InputDecoration(
                      labelText: 'Co ile',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      final interval = int.tryParse(value ?? '');
                      if (interval == null || interval < 1) {
                        return 'Min. 1';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      final interval = int.tryParse(value);
                      if (interval != null && interval > 0) {
                        setState(() {
                          _periodInterval = interval;
                          _updateNextPaymentDate();
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNextPaymentDatePicker() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Data następnej płatności',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _nextPaymentDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
                );
                if (date != null) {
                  setState(() {
                    _nextPaymentDate = date;
                  });
                }
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today),
                    const SizedBox(width: 12),
                    Text(
                      '${_nextPaymentDate.day.toString().padLeft(2, '0')}.${_nextPaymentDate.month.toString().padLeft(2, '0')}.${_nextPaymentDate.year}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _updateNextPaymentDate() {
    final now = DateTime.now();
    switch (_selectedPeriodType) {
      case 'daily':
        _nextPaymentDate = now.add(Duration(days: _periodInterval));
        break;
      case 'weekly':
        _nextPaymentDate = now.add(Duration(days: _periodInterval * 7));
        break;
      case 'monthly':
        _nextPaymentDate = DateTime(now.year, now.month + _periodInterval, now.day);
        break;
      case 'yearly':
        _nextPaymentDate = DateTime(now.year + _periodInterval, now.month, now.day);
        break;
    }
  }

  void _saveSubscription() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final authState = context.read<AuthBloc>().state;
    if (authState is! AuthAuthenticated) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Błąd uwierzytelnienia'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final cost = double.parse(_costController.text.replaceAll(',', '.'));
    final now = DateTime.now();
    
    final subscription = Subscription(
      id: isEditing ? widget.subscriptionId! : '',
      userId: authState.user.uid,
      title: _titleController.text.trim(),
      category: _selectedCategory,
      cost: cost,
      currency: 'PLN',
      lastPaidAt: now.subtract(Duration(days: 30)), // Przykładowa data ostatniej płatności
      nextPaymentAt: _nextPaymentDate,
      period: SubscriptionPeriod(
        type: _selectedPeriodType,
        interval: _periodInterval,
      ),
      notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
      iconPath: _selectedIcon,
      createdAt: now,
      updatedAt: now,
    );

    if (isEditing) {
      context.read<SubscriptionsBloc>().add(SubscriptionUpdateRequested(subscription));
    } else {
      context.read<SubscriptionsBloc>().add(SubscriptionAddRequested(subscription));
    }

    LoggerService.info('Zapisywanie subskrypcji: ${subscription.title}');
  }
}
