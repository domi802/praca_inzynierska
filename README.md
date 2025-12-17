# Substracto - Aplikacja do zarządzania subskrypcjami (Flutter)

Substracto to wieloplatformowa aplikacja (Android, iOS, macOS, Web, Windows, Linux) ułatwiająca zarządzanie płatnymi subskrypcjami. Projekt powstał w ramach pracy inżynierskiej i wykorzystuje ekosystem Firebase, wzorzec BLoC, oraz nowoczesne rozwiązania Flutter.

## Spis treści
- Funkcje
- Wymagania
- Instalacja
- Konfiguracja Firebase
- Uruchomienie
- Lokalizacja (i18n)
- Struktura projektu
- Testy
- Generowanie ikon aplikacji
- Rozwiązywanie problemów

## Funkcje
- Integracja z **Firebase**: `Auth`, `Cloud Firestore`, `Storage`, logowanie przez Google.
- Zarządzanie stanem przez **BLoC** (`flutter_bloc`, `bloc`, `equatable`).
- **Routing** z `go_router`.
- **Powiadomienia lokalne** z obsługą stref czasowych (`flutter_local_notifications`, `timezone`).
- Integracja z **kalendarzem systemowym** (`device_calendar`) oraz obsługa **uprawnień** (`permission_handler`).
- **Lokalizacja** (PL/EN) i generowanie lokalizacji na podstawie `l10n.yaml`.
- **Widgety domowe** (Android/iOS) dzięki `home_widget`.
- Obsługa obrazów i ikon: `image_picker`, `flutter_svg`, `cached_network_image`.
- Preferencje i ustawienia użytkownika (`shared_preferences`).

## Wymagania
- Flutter (zalecane najnowsze stabilne wydanie 3.x)
- Dart SDK 3.8+
- Narzędzia platformowe: Xcode (iOS/macOS), Android SDK (Android)
- Projekt i konfiguracja w Firebase (lub skorzystanie z istniejących plików w repo)

## Instalacja
1. Sklonuj repozytorium:
```bash
git clone <URL-repozytorium>
cd praca_inzynierska
```
2. Zainstaluj zależności:
```bash
flutter pub get
```
3. (iOS/macOS) Zainstaluj zależności CocoaPods, jeśli wymagane:
```bash
cd ios
pod install
cd -
```

## Konfiguracja Firebase
Projekt korzysta z automatycznej konfiguracji (`firebase_options.dart`). Jeśli konfigurujesz własne środowisko:

1. Zainstaluj `flutterfire_cli` i skonfiguruj projekt:
```bash
dart pub global activate flutterfire_cli
flutterfire configure
```
2. Upewnij się, że pliki konfiguracyjne są obecne:
- Android: `android/app/google-services.json` (w repo już znajduje się przykładowy plik)
- iOS: `ios/Runner/GoogleService-Info.plist`
- macOS: `macos/Runner/GoogleService-Info.plist` (opcjonalnie, jeśli używasz na macOS)

3. Inicjalizacja `Firebase` odbywa się w `lib/main.dart` przy użyciu `DefaultFirebaseOptions.currentPlatform`.

## Uruchomienie
- Android:
```bash
flutter run -d android
```
- iOS (wymaga uruchomionego symulatora lub podłączonego urządzenia i Xcode):
```bash
flutter run -d ios
```
- macOS:
```bash
flutter run -d macos
```
- Web (Chrome):
```bash
flutter run -d chrome
```
- Windows/Linux (jeśli skonfigurowane):
```bash
flutter run -d windows
# lub
flutter run -d linux
```

## Lokalizacja (i18n)
- Pliki tłumaczeń znajdują się w `lib/l10n/` i są sterowane przez `l10n.yaml`.
- Flutter generuje lokalizacje automatycznie podczas budowy/uruchomienia. W razie potrzeby możesz wymusić generowanie:
```bash
flutter gen-l10n
```
- Aplikacja domyślnie wspiera języki: PL oraz EN.

## Struktura projektu
Najważniejsze katalogi i pliki:
- `lib/main.dart` — punkt wejścia aplikacji, inicjalizacja Firebase, powiadomień i BLoC.
- `lib/app/` — kompozycja głównej aplikacji (`App`).
- `lib/core/` — serwisy, narzędzia wspólne (np. `NotificationService`, `LoggerService`).
- `lib/features/` — moduły domenowe:
	- `auth/` — logowanie i uwierzytelnianie (`AuthBloc`).
	- `subscriptions/` — zarządzanie subskrypcjami (`SubscriptionsBloc`).
	- `settings/` — ustawienia i preferencje (`SettingsCubit`).
- `assets/images/`, `assets/icons/` — grafika, ikony.
- `android/`, `ios/`, `macos/`, `web/`, `windows/`, `linux/` — konfiguracje platformowe.
- `pubspec.yaml` — zależności, konfiguracje (m.in. `flutter_launcher_icons`, assets, lokalizacja).

## Generowanie ikon aplikacji
Projekt używa `flutter_launcher_icons` do generowania ikon na wielu platformach. Po aktualizacji grafiki uruchom:
```bash
flutter pub run flutter_launcher_icons:main
```
Konfiguracja znajduje się w `pubspec.yaml` (sekcja `flutter_launcher_icons`).

## Rozwiązywanie problemów
- **Uprawnienia iOS**: jeśli dodajesz nowe integracje (np. kalendarz, kamera, biblioteka zdjęć), upewnij się, że w `Info.plist` masz odpowiednie klucze, np. `NSCalendarsUsageDescription`, `NSCameraUsageDescription`, `NSPhotoLibraryUsageDescription`.
- **Uprawnienia Android**: sprawdź `AndroidManifest.xml` i pamiętaj o wnioskowaniu o zgody w czasie działania (z `permission_handler`).
- **Firebase**: jeśli pojawią się błędy inicjalizacji, zweryfikuj poprawność plików `google-services.json`/`GoogleService-Info.plist` i zgodność identyfikatorów aplikacji.
- **Powiadomienia**: na iOS użytkownik musi wyrazić zgodę; upewnij się, że konfiguracja `NotificationService` jest poprawna i że strefy czasowe (`timezone`) są zainicjalizowane.

