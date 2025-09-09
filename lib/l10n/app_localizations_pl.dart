// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get appTitle => 'Menedżer Subskrypcji';

  @override
  String get login => 'Zaloguj się';

  @override
  String get register => 'Zarejestruj się';

  @override
  String get logout => 'Wyloguj się';

  @override
  String get loginToAccount => 'Zaloguj się do swojego konta';

  @override
  String get registerNewAccount => 'Utwórz nowe konto';

  @override
  String get emailAddress => 'Adres email';

  @override
  String get enterEmail => 'Wprowadź swój email';

  @override
  String get enterPassword => 'Wprowadź swoje hasło';

  @override
  String get pleaseEnterEmail => 'Podaj adres email';

  @override
  String get pleaseEnterPassword => 'Podaj hasło';

  @override
  String get pleaseEnterValidEmail => 'Podaj prawidłowy adres email';

  @override
  String get passwordTooShort => 'Hasło musi mieć co najmniej 6 znaków';

  @override
  String get resetPassword => 'Reset hasła';

  @override
  String get resetPasswordInstruction =>
      'Podaj adres email, na który wyślemy link do resetowania hasła.';

  @override
  String get passwordResetSent => 'Link do resetowania hasła został wysłany';

  @override
  String get sendResetLink => 'Wyślij link';

  @override
  String get userProfile => 'Profil użytkownika';

  @override
  String get appSettings => 'Ustawienia aplikacji';

  @override
  String get account => 'Konto';

  @override
  String get selectLanguage => 'Wybierz język';

  @override
  String get selectTheme => 'Wybierz motyw';

  @override
  String get error => 'Błąd';

  @override
  String get tryAgain => 'Spróbuj ponownie';

  @override
  String get noDataToDisplay => 'Brak danych do wyświetlenia';

  @override
  String get paymentCalendar => 'Kalendarz płatności';

  @override
  String get thisWeek => 'Ten tydzień';

  @override
  String get thisMonth => 'Ten miesiąc';

  @override
  String get details => 'Szczegóły';

  @override
  String get subscriptionMarkedPaid =>
      'Subskrypcja została oznaczona jako opłacona';

  @override
  String get todaySummary => 'Podsumowanie dzisiejsze';

  @override
  String get weeklySummary => 'Podsumowanie tygodniowe';

  @override
  String get monthlySummary => 'Podsumowanie miesięczne';

  @override
  String get paymentCount => 'Liczba płatności';

  @override
  String get totalCost => 'Łączny koszt';

  @override
  String get paymentsToday => 'Płatności dzisiaj';

  @override
  String get paymentsThisWeek => 'Płatności w tym tygodniu';

  @override
  String get paymentsThisMonth => 'Płatności w tym miesiącu';

  @override
  String get noPaymentsToday => 'Brak płatności na dzisiaj';

  @override
  String get noPaymentsThisWeek => 'Brak płatności w tym tygodniu';

  @override
  String get noPaymentsThisMonth => 'Brak płatności w tym miesiącu';

  @override
  String welcomeUser(String userName) {
    return 'Welcome $userName!';
  }

  @override
  String get mySubscriptions => 'Moje Subskrypcje';

  @override
  String get allSubscriptions => 'Wszystkie subskrypcje';

  @override
  String get dueTomorrow => 'Płatność jutro';

  @override
  String get dueToday => 'Płatność dzisiaj';

  @override
  String get period => 'Okres';

  @override
  String get paymentDates => 'Daty płatności';

  @override
  String get lastPayment => 'Ostatnia płatność';

  @override
  String get payToday => 'Płatność dzisiaj';

  @override
  String get additionalInfo => 'Dodatkowe informacje';

  @override
  String get reminder => 'Przypomnienie';

  @override
  String get createdDate => 'Data utworzenia';

  @override
  String get enabled => 'Włączone';

  @override
  String get daysBefore => 'dni przed';

  @override
  String daysBeforeParam(int days) {
    return '$days dni przed';
  }

  @override
  String get subscriptionIcon => 'Ikona subskrypcji';

  @override
  String get costPLN => 'Koszt (PLN)';

  @override
  String get type => 'Typ';

  @override
  String get howOften => 'Co ile';

  @override
  String get costSummary => 'Podsumowanie kosztów';

  @override
  String get averageCostPerSubscription => 'Średnia koszt na subskrypcję';

  @override
  String get perMonth => '/miesiąc';

  @override
  String get expensesByCategory => 'Wydatki wg kategorii';

  @override
  String totalCostWithCurrency(String cost) {
    return 'Łączny koszt: $cost PLN';
  }

  @override
  String get email => 'Email';

  @override
  String get password => 'Hasło';

  @override
  String get firstName => 'Imię';

  @override
  String get lastName => 'Nazwisko';

  @override
  String get confirmPassword => 'Potwierdź hasło';

  @override
  String get forgotPassword => 'Zapomniałeś hasła?';

  @override
  String get dontHaveAccount => 'Nie masz konta?';

  @override
  String get alreadyHaveAccount => 'Masz już konto?';

  @override
  String get createAccount => 'Utwórz konto';

  @override
  String get signInWithGoogle => 'Zaloguj się przez Google';

  @override
  String get or => 'lub';

  @override
  String get main => 'Główna';

  @override
  String get calendar => 'Kalendarz';

  @override
  String get add => 'Dodaj';

  @override
  String get stats => 'Statystyki';

  @override
  String get profile => 'Profil';

  @override
  String get subscriptions => 'Subskrypcje';

  @override
  String get addSubscription => 'Dodaj subskrypcję';

  @override
  String get editSubscription => 'Edytuj subskrypcję';

  @override
  String get subscriptionDetails => 'Szczegóły subskrypcji';

  @override
  String get subscriptionName => 'Nazwa subskrypcji';

  @override
  String get category => 'Kategoria';

  @override
  String get cost => 'Koszt';

  @override
  String get currency => 'Waluta';

  @override
  String get nextPayment => 'Następna płatność';

  @override
  String get paymentPeriod => 'Okres płatności';

  @override
  String get notes => 'Notatki';

  @override
  String get icon => 'Ikona';

  @override
  String get save => 'Zapisz';

  @override
  String get cancel => 'Anuluj';

  @override
  String get confirm => 'Zatwierdź';

  @override
  String get delete => 'Usuń';

  @override
  String get edit => 'Edytuj';

  @override
  String get daily => 'codziennie';

  @override
  String get weekly => 'tygodniowo';

  @override
  String get monthly => 'miesięcznie';

  @override
  String get yearly => 'rocznie';

  @override
  String get entertainment => 'Rozrywka';

  @override
  String get music => 'Muzyka';

  @override
  String get video => 'Video';

  @override
  String get gaming => 'Gry';

  @override
  String get productivity => 'Produktywność';

  @override
  String get education => 'Edukacja';

  @override
  String get fitness => 'Fitness';

  @override
  String get health => 'Zdrowie';

  @override
  String get shopping => 'Zakupy';

  @override
  String get transport => 'Transport';

  @override
  String get other => 'Inne';

  @override
  String get markAsPaid => 'Oznacz jako opłacone';

  @override
  String get deleteSubscription => 'Usuń subskrypcję';

  @override
  String get upcomingPayments => 'Nadchodzące płatności';

  @override
  String get overduePayments => 'Zaległe płatności';

  @override
  String get noSubscriptions => 'Brak subskrypcji';

  @override
  String get noSubscriptionsDescription =>
      'Dodaj swoją pierwszą subskrypcję, aby zacząć zarządzać wydatkami';

  @override
  String get today => 'Dziś';

  @override
  String get tomorrow => 'Jutro';

  @override
  String daysLeft(int days) {
    return 'Zostało $days dni';
  }

  @override
  String get overdue => 'Przeterminowane';

  @override
  String get totalMonthly => 'Łącznie miesięcznie';

  @override
  String get totalYearly => 'Łącznie rocznie';

  @override
  String get averagePerSubscription => 'Średnia na subskrypcję';

  @override
  String get mostExpensive => 'Najdroższe';

  @override
  String get cheapest => 'Najtańsze';

  @override
  String get settings => 'Ustawienia';

  @override
  String get editProfile => 'Edytuj profil';

  @override
  String get notifications => 'Powiadomienia';

  @override
  String get theme => 'Motyw';

  @override
  String get language => 'Język';

  @override
  String get security => 'Bezpieczeństwo';

  @override
  String get changePassword => 'Zmień hasło';

  @override
  String get lightTheme => 'Jasny';

  @override
  String get darkTheme => 'Ciemny';

  @override
  String get systemTheme => 'Systemowy';

  @override
  String get polish => 'Polski';

  @override
  String get english => 'Angielski';

  @override
  String get currentPassword => 'Obecne hasło';

  @override
  String get newPassword => 'Nowe hasło';

  @override
  String get confirmNewPassword => 'Potwierdź nowe hasło';

  @override
  String get enterCurrentPassword => 'Wprowadź obecne hasło';

  @override
  String get enterNewPassword => 'Wprowadź nowe hasło';

  @override
  String get passwordRequirements =>
      'Nowe hasło musi mieć co najmniej 6 znaków i zawierać litery oraz cyfry.';

  @override
  String get passwordsDoNotMatch => 'Hasła nie są identyczne';

  @override
  String get enableNotifications => 'Włącz powiadomienia';

  @override
  String get reminderDays => 'Dni przypomnienia wcześniej';

  @override
  String get notificationTime => 'Czas powiadomienia';

  @override
  String hello(String name) {
    return 'Witaj $name!';
  }

  @override
  String get errorGeneral => 'Wystąpił błąd. Spróbuj ponownie.';

  @override
  String get errorNetwork => 'Błąd sieci. Sprawdź połączenie.';

  @override
  String get errorAuth => 'Błąd uwierzytelnienia. Zaloguj się ponownie.';

  @override
  String get errorInvalidEmail => 'Nieprawidłowy adres email';

  @override
  String get errorWeakPassword => 'Hasło jest za słabe';

  @override
  String get errorEmailAlreadyInUse => 'Email jest już używany';

  @override
  String get errorUserNotFound => 'Użytkownik nie znaleziony';

  @override
  String get errorWrongPassword => 'Nieprawidłowe hasło';

  @override
  String get errorPasswordMismatch => 'Hasła nie pasują do siebie';

  @override
  String get success => 'Sukces';

  @override
  String get subscriptionAdded => 'Subskrypcja została dodana';

  @override
  String get subscriptionUpdated => 'Subskrypcja została zaktualizowana';

  @override
  String get subscriptionDeleted => 'Subskrypcja została usunięta';

  @override
  String get profileUpdated => 'Profil został zaktualizowany';

  @override
  String get passwordChanged => 'Hasło zostało zmienione';

  @override
  String get confirmDelete => 'Czy na pewno chcesz usunąć tę subskrypcję?';

  @override
  String get confirmLogout => 'Czy na pewno chcesz się wylogować?';

  @override
  String get yes => 'Tak';

  @override
  String get no => 'Nie';

  @override
  String get enterSubscriptionName => 'Wprowadź nazwę subskrypcji';

  @override
  String get enterCost => 'Wprowadź koszt';

  @override
  String get selectCategory => 'Wybierz kategorię';

  @override
  String get selectIcon => 'Wybierz ikonę';

  @override
  String get enterNotes => 'Wprowadź notatki (opcjonalnie)';

  @override
  String get selectDate => 'Wybierz datę';

  @override
  String get enterFirstName => 'Wprowadź imię';

  @override
  String get enterLastName => 'Wprowadź nazwisko';

  @override
  String get pleaseEnterFirstName => 'Podaj swoje imię';

  @override
  String get pleaseEnterLastName => 'Podaj swoje nazwisko';

  @override
  String get emailCannotBeChanged => 'Email nie może być zmieniony';

  @override
  String get accountEmail => 'Email konta';

  @override
  String get saveChanges => 'Zapisz zmiany';

  @override
  String get validation_required => 'To pole jest wymagane';

  @override
  String get validation_email => 'Wprowadź prawidłowy adres email';

  @override
  String get validation_password => 'Hasło musi mieć co najmniej 6 znaków';

  @override
  String get validation_passwordMatch => 'Hasła muszą być identyczne';

  @override
  String get validation_cost => 'Wprowadź prawidłowy koszt';

  @override
  String get validation_name => 'Wprowadź prawidłowe imię/nazwisko';

  @override
  String paymentDate(String date) {
    return 'Płatność: $date';
  }

  @override
  String get subscriptionMarkedAsPaid =>
      'Subskrypcja została oznaczona jako opłacona';

  @override
  String get allCurrentSubscriptionsPaid =>
      'Wszystkie bieżące subskrypcje są opłacone';

  @override
  String get paymentTomorrow => 'Płatność jutro';

  @override
  String daysUntilPayment(int days) {
    return '$days dni do płatności';
  }

  @override
  String get addFirstSubscription =>
      'Dodaj swoją pierwszą subskrypcję, aby zacząć zarządzać wydatkami';

  @override
  String confirmDeleteSubscription(String title) {
    return 'Czy na pewno chcesz usunąć subskrypcję \"$title\"? Tej operacji nie można cofnąć.';
  }

  @override
  String get markingAsPaid => 'Oznaczanie jako opłacone...';

  @override
  String get enterValidCost => 'Podaj prawidłowy koszt';

  @override
  String get updateSubscription => 'Zaktualizuj subskrypcję';

  @override
  String get nextPaymentDate => 'Data następnej płatności';

  @override
  String get paymentDateLabel => 'Data płatności';

  @override
  String paymentOverdue(int days) {
    return 'Płatność przeterminowana ($days dni)';
  }

  @override
  String paymentInDays(int days) {
    return 'Płatność za $days dni';
  }

  @override
  String get authenticationError => 'Błąd uwierzytelnienia';

  @override
  String get defaultIcon => 'Domyślna';

  @override
  String get subscriptionNotFound => 'Subskrypcja nie została znaleziona';

  @override
  String get disabled => 'Wyłączone';

  @override
  String get createNewAccount => 'Utwórz nowe konto';

  @override
  String get fillFormToCreateAccount => 'Wypełnij formularz aby założyć konto';

  @override
  String get provideFirstName => 'Podaj imię';

  @override
  String get firstNameMinLength => 'Imię musi mieć co najmniej 2 znaki';

  @override
  String get lastNameMinLength => 'Nazwisko musi mieć co najmniej 2 znaki';

  @override
  String get provideValidEmail => 'Podaj prawidłowy adres email';

  @override
  String get providePassword => 'Podaj hasło';

  @override
  String get passwordMinLength => 'Hasło musi mieć co najmniej 6 znaków';

  @override
  String get enterPasswordAgain => 'Wprowadź hasło ponownie';

  @override
  String get repeatPasswordField => 'Powtórz hasło';

  @override
  String get passwordsNotMatch => 'Hasła nie są identyczne';

  @override
  String get alreadyHaveAccountQuestion => 'Masz już konto? ';

  @override
  String get every3Days => 'co 3 dni';

  @override
  String get biweekly => 'co 2 tygodnie';

  @override
  String get quarterly => 'co kwartał';

  @override
  String get paymentHistory => 'Daty płatności';

  @override
  String get lastPaymentLabel => 'Ostatnia płatność';

  @override
  String get nextPaymentLabel => 'Następna płatność';

  @override
  String get additionalInformation => 'Dodatkowe informacje';

  @override
  String get creationDate => 'Data utworzenia';

  @override
  String get markAsPaidButton => 'Oznacz jako opłacona';

  @override
  String get deleteButton => 'Usuń';

  @override
  String get periodDaily => 'codziennie';

  @override
  String get periodWeekly => 'tygodniowo';

  @override
  String get periodMonthly => 'miesięcznie';

  @override
  String get periodYearly => 'rocznie';

  @override
  String get period3Days => 'co 3 dni';

  @override
  String get periodBiweekly => 'co 2 tygodnie';

  @override
  String get periodQuarterly => 'co kwartał';

  @override
  String get addSubscriptionsToSeeStats =>
      'Dodaj subskrypcje, aby zobaczyć statystyki';

  @override
  String get paymentPeriods => 'Okresy płatności';

  @override
  String get mostExpensiveSubscriptions => 'Najdroższe subskrypcje';

  @override
  String get noPaymentsNext7Days => 'Brak płatności w ciągu najbliższych 7 dni';

  @override
  String get subscriptionTitle => 'Nazwa subskrypcji';

  @override
  String get subscriptionCost => 'Koszt subskrypcji';

  @override
  String get reminderDaysBefore => 'Przypomnienie (dni przed)';

  @override
  String get editMenuItem => 'Edytuj';

  @override
  String get viewMenuItem => 'Szczegóły';

  @override
  String get markAsPaidMenuItem => 'Oznacz jako opłacone';

  @override
  String get deleteMenuItem => 'Usuń';

  @override
  String everyXDays(int days) {
    return 'Co $days dni';
  }

  @override
  String everyXWeeks(int weeks) {
    return 'Co $weeks tygodni';
  }

  @override
  String everyXMonths(int months) {
    return 'Co $months miesiąc(e)';
  }

  @override
  String everyXYears(int years) {
    return 'Co $years lat(a)';
  }

  @override
  String get categoryBreakdown => 'Podział według kategorii';

  @override
  String get totalAmount => 'Całkowita kwota';

  @override
  String get averagePerMonth => 'Średnia na miesiąc';

  @override
  String get categoryEntertainment => 'Rozrywka';

  @override
  String get categoryMusic => 'Muzyka';

  @override
  String get categoryVideo => 'Video';

  @override
  String get categoryGames => 'Gry';

  @override
  String get categoryProductivity => 'Produktywność';

  @override
  String get categoryEducation => 'Edukacja';

  @override
  String get categoryHealth => 'Zdrowie';

  @override
  String get categorySport => 'Sport';

  @override
  String get categoryFinance => 'Finanse';

  @override
  String get categoryOther => 'Inne';

  @override
  String get periodType => 'Typ';

  @override
  String get periodInterval => 'Co ile';

  @override
  String get paymentToday => 'Płatność dziś';

  @override
  String get paidThisMonth => 'Opłacone w tym miesiącu';

  @override
  String daysToPayment(int days) {
    return '$days dni do płatności';
  }

  @override
  String daysShort(int days) {
    return '$days dni';
  }

  @override
  String get monthlyLabel => 'Miesięcznie';

  @override
  String get yearlyLabel => 'Rocznie';

  @override
  String get subscriptionNotFoundForEdit =>
      'Nie znaleziono subskrypcji do edycji';

  @override
  String get subscriptionNameHint => 'np. Netflix, Spotify...';

  @override
  String get minimumOne => 'Min. 1';

  @override
  String get notesHint => 'Dodatkowe informacje...';

  @override
  String get loadingChangingPassword => 'Zmiana hasła...';

  @override
  String get loadingUpdatingProfile => 'Aktualizowanie profilu...';

  @override
  String get loadingUpdatingSubscription => 'Aktualizowanie subskrypcji...';

  @override
  String get loadingDeletingSubscription => 'Usuwanie subskrypcji...';

  @override
  String get loadingMarkingAsPaid => 'Oznaczanie jako opłacone...';

  @override
  String get loadingProcessing => 'Przetwarzanie...';

  @override
  String get loadingPleaseWait => 'Proszę czekać...';

  @override
  String get loadingDefault => 'Ładowanie...';

  @override
  String errorChangingPassword(String error) {
    return 'Błąd podczas zmiany hasła: $error';
  }

  @override
  String get errorInitializingApp => 'Błąd podczas inicjalizacji aplikacji';

  @override
  String get errorLoadingApp => 'Błąd ładowania aplikacji';

  @override
  String get errorPageTitle => 'Błąd';

  @override
  String get errorLogin => 'Wystąpił błąd podczas logowania';

  @override
  String get errorRegister => 'Wystąpił błąd podczas rejestracji';

  @override
  String get errorInvalidLogin => 'Błędny login lub hasło';

  @override
  String get errorEmailAlreadyExists =>
      'Konto z tym adresem email już istnieje';

  @override
  String get errorWeakPasswordAuth => 'Hasło jest zbyt słabe';

  @override
  String get errorUserDisabled => 'Konto użytkownika zostało zablokowane';

  @override
  String get errorTooManyRequests =>
      'Zbyt wiele prób logowania. Spróbuj ponownie później';

  @override
  String get errorOperationNotAllowed => 'Operacja nie jest dozwolona';

  @override
  String get errorNetworkFailed => 'Brak połączenia z internetem';

  @override
  String get errorGenericAuth => 'Wystąpił błąd. Spróbuj ponownie później';

  @override
  String get errorUnexpected => 'Wystąpił nieoczekiwany błąd';

  @override
  String get errorUserDataNotFound => 'Nie znaleziono danych użytkownika';

  @override
  String get verifyYourEmail => 'Zweryfikuj swój email';

  @override
  String get checkEmailForVerification =>
      'Sprawdź swoją skrzynkę pocztową i kliknij link weryfikacyjny.';

  @override
  String get checkVerification => 'Sprawdź weryfikację';

  @override
  String get resendEmail => 'Wyślij ponownie';

  @override
  String get hide => 'Ukryj';

  @override
  String get emailVerificationSent =>
      'Email weryfikacyjny został wysłany ponownie';

  @override
  String get emailVerified => 'Email został zweryfikowany! 🎉';

  @override
  String get continueWithGoogle => 'Kontynuuj z Google';

  @override
  String get orSignInWith => 'Lub zaloguj się przez';

  @override
  String get orSignUpWith => 'Lub zarejestruj się przez';

  @override
  String get enterValidEmail => 'Wprowadź prawidłowy adres email';
}
