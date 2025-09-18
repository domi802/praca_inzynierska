class PasswordValidator {
  /// Waliduje hasło sprawdzając czy spełnia wszystkie wymagania:
  /// - Co najmniej 6 znaków
  /// - Co najmniej jedna cyfra
  /// - Co najmniej jedna duża litera
  /// - Co najmniej jeden znak specjalny
  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Hasło jest wymagane';
    }

    // Sprawdź minimalną długość
    if (password.length < 6) {
      return 'Hasło musi mieć co najmniej 6 znaków';
    }

    // Sprawdź czy zawiera cyfrę
    if (!RegExp(r'[0-9]').hasMatch(password)) {
      return 'Hasło musi zawierać co najmniej jedną cyfrę';
    }

    // Sprawdź czy zawiera dużą literę
    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      return 'Hasło musi zawierać co najmniej jedną dużą literę';
    }

    // Sprawdź czy zawiera znak specjalny
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) {
      return 'Hasło musi zawierać co najmniej jeden znak specjalny';
    }

    return null; // Hasło jest prawidłowe
  }

  /// Waliduje hasło z ogólnym komunikatem błędu
  static String? validatePasswordGeneral(String? password, {
    String? requiredMessage,
    String? allRequirementsMustBeMetMessage,
  }) {
    if (password == null || password.isEmpty) {
      return requiredMessage ?? 'Hasło jest wymagane';
    }

    // Sprawdź wszystkie wymagania naraz
    bool isValid = hasMinLength(password) && 
                   hasDigit(password) && 
                   hasUppercase(password) && 
                   hasSpecialChar(password);

    if (!isValid) {
      return allRequirementsMustBeMetMessage ?? 'Wszystkie warunki muszą być spełnione';
    }

    return null; // Hasło jest prawidłowe
  }

  /// Waliduje hasło z lokalizowanymi komunikatami
  static String? validatePasswordWithLocalizations(String? password, {
    String? requiredMessage,
    String? minLengthMessage,
    String? digitRequiredMessage,
    String? uppercaseRequiredMessage,
    String? specialCharRequiredMessage,
  }) {
    if (password == null || password.isEmpty) {
      return requiredMessage ?? 'Hasło jest wymagane';
    }

    // Sprawdź minimalną długość
    if (password.length < 6) {
      return minLengthMessage ?? 'Hasło musi mieć co najmniej 6 znaków';
    }

    // Sprawdź czy zawiera cyfrę
    if (!RegExp(r'[0-9]').hasMatch(password)) {
      return digitRequiredMessage ?? 'Hasło musi zawierać co najmniej jedną cyfrę';
    }

    // Sprawdź czy zawiera dużą literę
    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      return uppercaseRequiredMessage ?? 'Hasło musi zawierać co najmniej jedną dużą literę';
    }

    // Sprawdź czy zawiera znak specjalny
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) {
      return specialCharRequiredMessage ?? 'Hasło musi zawierać co najmniej jeden znak specjalny';
    }

    return null; // Hasło jest prawidłowe
  }

  /// Sprawdza czy hasło ma wymaganą długość
  static bool hasMinLength(String password, [int minLength = 6]) {
    return password.length >= minLength;
  }

  /// Sprawdza czy hasło zawiera cyfrę
  static bool hasDigit(String password) {
    return RegExp(r'[0-9]').hasMatch(password);
  }

  /// Sprawdza czy hasło zawiera dużą literę
  static bool hasUppercase(String password) {
    return RegExp(r'[A-Z]').hasMatch(password);
  }

  /// Sprawdza czy hasło zawiera znak specjalny
  static bool hasSpecialChar(String password) {
    return RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password);
  }

  /// Zwraca listę wszystkich niespełnionych wymagań
  static List<String> getUnmetRequirements(String password) {
    List<String> unmet = [];
    
    if (!hasMinLength(password)) {
      unmet.add('Co najmniej 6 znaków');
    }
    
    if (!hasDigit(password)) {
      unmet.add('Co najmniej jedna cyfra');
    }
    
    if (!hasUppercase(password)) {
      unmet.add('Co najmniej jedna duża litera');
    }
    
    if (!hasSpecialChar(password)) {
      unmet.add('Co najmniej jeden znak specjalny');
    }
    
    return unmet;
  }
}