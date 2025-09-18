import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'user_model.dart';
import '../../../core/services/logger_service.dart';
import '../../../app/constants.dart';

/// Repozytorium do zarządzania uwierzytelnianiem i danymi użytkownika
class AuthRepository {
  final firebase_auth.FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final GoogleSignIn _googleSignIn;

  AuthRepository({
    firebase_auth.FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
    GoogleSignIn? googleSignIn,
  })  : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn();

  /// Stream zmian stanu uwierzytelnienia
  Stream<firebase_auth.User?> get authStateChanges =>
      _firebaseAuth.authStateChanges();

  /// Aktualnie zalogowany użytkownik Firebase
  firebase_auth.User? get currentUser => _firebaseAuth.currentUser;

  /// Logowanie użytkownika email i hasłem
  Future<firebase_auth.User> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (credential.user == null) {
        throw Exception('Nie udało się zalogować użytkownika');
      }
      
      return credential.user!;
    } on firebase_auth.FirebaseAuthException {
      rethrow;
    } catch (e) {
      LoggerService.error('Błąd podczas logowania', e);
      throw Exception('Wystąpił błąd podczas logowania');
    }
  }

  /// Rejestracja nowego użytkownika
  Future<firebase_auth.User> createUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (credential.user == null) {
        throw Exception('Nie udało się utworzyć konta użytkownika');
      }
      
      return credential.user!;
    } on firebase_auth.FirebaseAuthException {
      rethrow;
    } catch (e) {
      LoggerService.error('Błąd podczas rejestracji', e);
      throw Exception('Wystąpił błąd podczas rejestracji');
    }
  }

  /// Wylogowanie użytkownika
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      LoggerService.error('Błąd podczas wylogowania', e);
      throw Exception('Wystąpił błąd podczas wylogowania');
    }
  }

  /// Reset hasła
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on firebase_auth.FirebaseAuthException {
      rethrow;
    } catch (e) {
      LoggerService.error('Błąd podczas wysyłania emaila resetującego', e);
      throw Exception('Wystąpił błąd podczas wysyłania emaila resetującego');
    }
  }

  /// Wysyła email weryfikacyjny
  Future<void> sendEmailVerification() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        LoggerService.info('Email weryfikacyjny wysłany do: ${user.email}');
      }
    } catch (e) {
      LoggerService.error('Błąd podczas wysyłania emaila weryfikacyjnego', e);
      throw Exception('Nie udało się wysłać emaila weryfikacyjnego');
    }
  }

  /// Sprawdza czy email jest zweryfikowany
  bool get isEmailVerified => _firebaseAuth.currentUser?.emailVerified ?? false;

  /// Odświeża dane użytkownika (sprawdza weryfikację email)
  Future<void> reloadUser() async {
    try {
      await _firebaseAuth.currentUser?.reload();
    } catch (e) {
      LoggerService.error('Błąd podczas odświeżania danych użytkownika', e);
    }
  }

  /// Logowanie przez Google
  Future<firebase_auth.User> signInWithGoogle() async {
    try {
      // Rozpocznij proces logowania Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        throw Exception('Logowanie Google zostało anulowane');
      }

      // Uzyskaj szczegóły uwierzytelnienia
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Utwórz credential Firebase
      final credential = firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Zaloguj do Firebase
      final userCredential = await _firebaseAuth.signInWithCredential(credential);
      
      if (userCredential.user == null) {
        throw Exception('Nie udało się zalogować przez Google');
      }

      // Sprawdź czy to nowy użytkownik
      if (userCredential.additionalUserInfo?.isNewUser == true) {
        // Zapisz dane nowego użytkownika
        final user = User(
          uid: userCredential.user!.uid,
          email: userCredential.user!.email ?? '',
          firstName: userCredential.user!.displayName?.split(' ').first ?? '',
          lastName: userCredential.user!.displayName?.split(' ').skip(1).join(' ') ?? '',
          photoUrl: userCredential.user!.photoURL,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        await saveUserData(user);
      }

      LoggerService.info('Użytkownik zalogowany przez Google: ${userCredential.user!.email}');
      return userCredential.user!;
    } catch (e) {
      LoggerService.error('Błąd podczas logowania przez Google', e);
      rethrow;
    }
  }

  /// Wylogowanie z Google
  Future<void> signOutGoogle() async {
    try {
      await _googleSignIn.signOut();
      await _firebaseAuth.signOut();
    } catch (e) {
      LoggerService.error('Błąd podczas wylogowania z Google', e);
      throw Exception('Nie udało się wylogować z Google');
    }
  }

  /// Zapisuje dane użytkownika w Firestore
  Future<void> saveUserData(User user) async {
    try {
      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(user.uid)
          .set(user.toMap());
          
      LoggerService.info('Dane użytkownika zostały zapisane: ${user.uid}');
    } catch (e) {
      LoggerService.error('Błąd podczas zapisywania danych użytkownika', e);
      throw Exception('Nie udało się zapisać danych użytkownika');
    }
  }

  /// Pobiera dane użytkownika z Firestore
  Future<User?> getUserData(String uid) async {
    try {
      final doc = await _firestore
          .collection(AppConstants.usersCollection)
          .doc(uid)
          .get();
          
      if (!doc.exists || doc.data() == null) {
        LoggerService.warning('Nie znaleziono danych użytkownika: $uid');
        return null;
      }
      
      return User.fromMap(doc.data()!);
    } catch (e) {
      LoggerService.error('Błąd podczas pobierania danych użytkownika', e);
      throw Exception('Nie udało się pobrać danych użytkownika');
    }
  }

  /// Aktualizuje dane użytkownika w Firestore
  Future<void> updateUserData(User user) async {
    try {
      final updatedUser = user.copyWith(updatedAt: DateTime.now());
      
      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(user.uid)
          .update(updatedUser.toMap());
          
      LoggerService.info('Dane użytkownika zostały zaktualizowane: ${user.uid}');
    } catch (e) {
      LoggerService.error('Błąd podczas aktualizacji danych użytkownika', e);
      throw Exception('Nie udało się zaktualizować danych użytkownika');
    }
  }

  /// Usuwa konto użytkownika (Firebase Auth i Firestore)
  Future<void> deleteUserAccount() async {
    try {
      final currentUser = _firebaseAuth.currentUser;
      if (currentUser == null) {
        throw Exception('Brak zalogowanego użytkownika');
      }
      
      // Usuń dane z Firestore
      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(currentUser.uid)
          .delete();
      
      // Usuń konto Firebase Auth
      await currentUser.delete();
      
      LoggerService.info('Konto użytkownika zostało usunięte: ${currentUser.uid}');
    } catch (e) {
      LoggerService.error('Błąd podczas usuwania konta użytkownika', e);
      throw Exception('Nie udało się usunąć konta użytkownika');
    }
  }

  /// Sprawdza czy email jest już używany
  Future<bool> isEmailInUse(String email) async {
    try {
      final signInMethods = await _firebaseAuth.fetchSignInMethodsForEmail(email);
      return signInMethods.isNotEmpty;
    } catch (e) {
      LoggerService.error('Błąd podczas sprawdzania dostępności emaila', e);
      return false;
    }
  }

  /// Ponowne uwierzytelnienie użytkownika (wymagane przed wrażliwymi operacjami)
  Future<void> reauthenticateUser(String password) async {
    try {
      final currentUser = _firebaseAuth.currentUser;
      if (currentUser == null || currentUser.email == null) {
        throw Exception('Brak zalogowanego użytkownika');
      }
      
      final credential = firebase_auth.EmailAuthProvider.credential(
        email: currentUser.email!,
        password: password,
      );
      
      await currentUser.reauthenticateWithCredential(credential);
    } on firebase_auth.FirebaseAuthException {
      rethrow;
    } catch (e) {
      LoggerService.error('Błąd podczas ponownego uwierzytelnienia', e);
      throw Exception('Nie udało się ponownie uwierzytelnić użytkownika');
    }
  }

  /// Zmiana hasła użytkownika
  Future<void> changePassword(String currentPassword, String newPassword) async {
    try {
      final currentUser = _firebaseAuth.currentUser;
      if (currentUser == null) {
        throw Exception('Brak zalogowanego użytkownika');
      }
      
      // Najpierw ponownie uwierzytelnij użytkownika
      await reauthenticateUser(currentPassword);
      
      // Zmień hasło
      await currentUser.updatePassword(newPassword);
      
      LoggerService.info('Hasło zostało zmienione dla użytkownika: ${currentUser.uid}');
    } on firebase_auth.FirebaseAuthException {
      rethrow;
    } catch (e) {
      LoggerService.error('Błąd podczas zmiany hasła', e);
      throw Exception('Nie udało się zmienić hasła');
    }
  }
}
