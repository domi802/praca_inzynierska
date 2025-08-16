# Nowa Paleta Kolorów Aplikacji

## Podstawowe Kolory

### Główne kolory
- **Primary**: `#FFA726` - Pomarańczowy (główny kolor akcji)
- **Primary Variant**: `#FB8C00` - Ciemniejszy pomarańczowy
- **Secondary**: `#29B6F6` - Niebieski (dodatkowy kolor akcji)
- **Secondary Variant**: `#0288D1` - Ciemniejszy niebieski

### Tło i powierzchnie
- **Background**: `#FDFDFD` - Jasne tło
- **Surface**: `#FFFFFF` - Białe karty i powierzchnie
- **On Background**: `#212121` - Ciemny tekst na tle
- **On Surface**: `#757575` - Szary tekst na powierzchniach

### Kolory statusu
- **Success**: `#66BB6A` - Zielony (sukces, poprawne operacje)
- **Error**: `#E53935` - Czerwony (błędy, przeterminowane płatności)
- **Warning**: `#FFB300` - Żółty (ostrzeżenia, płatności dzisiaj/jutro)
- **Divider**: `#E0E0E0` - Linie podziału i obramowania

## Kolory do Wykresów

Zdefiniowana paleta kolorów do wizualizacji danych:
```dart
[
  Color(0xFFFFA726), // Primary - pomarańczowy
  Color(0xFF29B6F6), // Secondary - niebieski
  Color(0xFF66BB6A), // Success - zielony
  Color(0xFFAB47BC), // Purple - fioletowy
  Color(0xFFE53935), // Error - czerwony
  Color(0xFFFFB300), // Warning - żółty
  Color(0xFF9E9E9E), // Grey - szary
]
```

## Mapowanie Kolorów dla Kategorii

### Kategorie subskrypcji:
- **Rozrywka**: `#E53935` (czerwony)
- **Muzyka**: `#AB47BC` (fioletowy)
- **Video**: `#29B6F6` (niebieski)
- **Gry**: `#66BB6A` (zielony)
- **Produktywność**: `#FFB300` (żółty)
- **Edukacja**: `#0288D1` (ciemnoniebieski)
- **Sport**: `#FFA726` (pomarańczowy)
- **Zdrowie**: `#FB8C00` (ciemnopomarańczowy)
- **Finanse**: `#FFB300` (żółty)
- **Inne**: `#9E9E9E` (szary)

## Kolory Statusów Płatności

### Zgodnie z terminami:
- **Przeterminowane**: `#E53935` (czerwony)
- **Płatność dzisiaj**: `#FFB300` (żółty)
- **Płatność w ciągu 3 dni**: `#FFA726` (pomarańczowy)
- **Płatność na czas**: `#66BB6A` (zielony)

## Zastosowanie w Aplikacji

### Zaktualizowane komponenty:
1. **Główny motyw aplikacji** (`lib/app/theme.dart`)
2. **Ekran statystyk** - wszystkie wykresy i kolory kategorii
3. **Ekran kalendarza** - kolory statusów płatności
4. **Szczegóły subskrypcji** - kolory terminów płatności
5. **Lista subskrypcji** - kolory przypomnień i statusów
6. **Manifest aplikacji web** - kolory motywu

### Dodane pliki pomocnicze:
- `lib/app/chart_colors.dart` - klasa pomocnicza z kolorami do wykresów

## Zgodność z Material Design 3

Nowa paleta kolorów jest w pełni kompatybilna z Material Design 3 i wykorzystuje system `ColorScheme.fromSeed()` do generowania spójnych kolorów motywu.

Kolory zostały dobrane tak, aby zapewniać:
- Dobry kontrast i czytelność
- Spójność wizualną
- Intuicyjne kodowanie kolorami (czerwony = problem, zielony = ok, itp.)
- Przyjazność dla osób z zaburzeniami widzenia kolorów
