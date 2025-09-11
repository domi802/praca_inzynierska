# Fix: Problem z danymi subskrypcji po zmianie użytkownika

## Problem
Po przełączeniu użytkownika w aplikacji dane subskrypcji z poprzedniego konta pozostawały w pamięci do momentu ponownego uruchomienia aplikacji. To oznaczało, że nowy użytkownik widział subskrypcje poprzedniego użytkownika, co stanowiło poważny problem bezpieczeństwa i UX.

## Przyczyna
Problem wynikał z tego, że:
1. `SubscriptionsBloc` nie nasłuchiwał zmian w `AuthBloc`
2. Dane subskrypcji były ładowane tylko raz w `initState()` ekranu `SubscriptionsListScreen`
3. Brak mechanizmu czyszczenia stanu przy zmianie użytkownika
4. Powiadomienia związane z poprzednim użytkownikiem pozostawały aktywne

## Rozwiązanie

### 1. Dodano nowy event w SubscriptionsBloc
```dart
class SubscriptionsClearRequested extends SubscriptionsEvent {}
```

### 2. Implementowano obsługę czyszczenia stanu
```dart
Future<void> _onSubscriptionsClearRequested(
  SubscriptionsClearRequested event,
  Emitter<SubscriptionsState> emit,
) async {
  try {
    // Wyczyść wszystkie zaplanowane powiadomienia
    await NotificationService.instance.cancelAllNotifications();
    LoggerService.info('Anulowano wszystkie powiadomienia przy zmianie użytkownika');
  } catch (e) {
    LoggerService.error('Błąd podczas anulowania powiadomień', e);
  }
  
  emit(SubscriptionsInitial());
  LoggerService.info('Wyczyszczono stan subskrypcji');
}
```

### 3. Dodano nasłuchiwanie zmian AuthBloc w SubscriptionsListScreen
```dart
MultiBlocListener(
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
    // ... reszta listener-ów
  ],
  // ...
)
```

## Przepływ działania po zmianach

1. **Wylogowanie użytkownika:**
   - `AuthBloc` emituje `AuthUnauthenticated`
   - `SubscriptionsListScreen` wykrywa zmianę i wysyła `SubscriptionsClearRequested`
   - `SubscriptionsBloc` czyści stan i anuluje wszystkie powiadomienia

2. **Logowanie nowego użytkownika:**
   - `AuthBloc` emituje `AuthAuthenticated` z danymi nowego użytkownika
   - `SubscriptionsListScreen` wykrywa zmianę i wysyła `SubscriptionsLoadRequested`
   - `SubscriptionsBloc` ładuje subskrypcje dla nowego użytkownika

## Testowanie

### Test manualny:
1. Zaloguj się na konto A
2. Dodaj kilka subskrypcji
3. Wyloguj się (w ustawieniach)
4. Zaloguj się na konto B
5. Sprawdź czy widzisz tylko subskrypcje konta B (nie powinny być widoczne subskrypcje z konta A)

### Test powiadomień:
1. Zaloguj się na konto A
2. Dodaj subskrypcję z krótkim przypomnieniem
3. Wyloguj się
4. Sprawdź czy powiadomienia zostały anulowane
5. Zaloguj się na konto B
6. Dodaj subskrypcję - powinny zostać zaplanowane nowe powiadomienia

## Pliki zmodyfikowane:
- `lib/features/subscriptions/logic/subscriptions_bloc.dart`
- `lib/features/subscriptions/presentation/subscriptions_list_screen.dart`

## Bezpieczeństwo
To rozwiązanie zapewnia, że:
- Użytkownicy nie widzą danych innych użytkowników
- Powiadomienia są prawidłowo zarządzane per użytkownik
- Stan aplikacji jest czysty przy każdej zmianie użytkownika
