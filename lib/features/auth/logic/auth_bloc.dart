import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import '../data/user_model.dart';
import '../data/auth_repository.dart';
import '../../../core/services/logger_service.dart';
import '../../../core/services/localization_service.dart';

// Events
abstract class AuthEvent extends Equatable {
  const AuthEvent();
  
  @override
  List<Object?> get props => [];
}

class AuthInitialized extends AuthEvent {}

class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;
  
  const AuthLoginRequested({
    required this.email,
    required this.password,
  });
  
  @override
  List<Object?> get props => [email, password];
}

class AuthRegisterRequested extends AuthEvent {
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  
  const AuthRegisterRequested({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
  });
  
  @override
  List<Object?> get props => [email, password, firstName, lastName];
}

class AuthLogoutRequested extends AuthEvent {}

class AuthGoogleSignInRequested extends AuthEvent {}

class AuthEmailVerificationRequested extends AuthEvent {}

class AuthPasswordResetRequested extends AuthEvent {
  final String email;
  
  const AuthPasswordResetRequested({required this.email});
  
  @override
  List<Object?> get props => [email];
}

class AuthPasswordChangeRequested extends AuthEvent {
  final String currentPassword;
  final String newPassword;
  
  const AuthPasswordChangeRequested({
    required this.currentPassword,
    required this.newPassword,
  });
  
  @override
  List<Object?> get props => [currentPassword, newPassword];
}

class AuthUserChanged extends AuthEvent {
  final firebase_auth.User? firebaseUser;
  
  const AuthUserChanged(this.firebaseUser);
  
  @override
  List<Object?> get props => [firebaseUser];
}

// States
abstract class AuthState extends Equatable {
  const AuthState();
  
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final User user;
  
  const AuthAuthenticated(this.user);
  
  @override
  List<Object?> get props => [user];
}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;
  
  const AuthError(this.message);
  
  @override
  List<Object?> get props => [message];
}

class AuthPasswordChangeSuccess extends AuthState {
  final User user;
  
  const AuthPasswordChangeSuccess(this.user);
  
  @override
  List<Object?> get props => [user];
}

// BLoC
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  
  AuthBloc({AuthRepository? authRepository})
      : _authRepository = authRepository ?? AuthRepository(),
        super(AuthInitial()) {
    
    // Nasłuchuj zmian stanu uwierzytelnienia Firebase
    _authRepository.authStateChanges.listen((firebaseUser) {
      add(AuthUserChanged(firebaseUser));
    });
    
    on<AuthInitialized>(_onAuthInitialized);
    on<AuthLoginRequested>(_onAuthLoginRequested);
    on<AuthRegisterRequested>(_onAuthRegisterRequested);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);
    on<AuthGoogleSignInRequested>(_onAuthGoogleSignInRequested);
    on<AuthEmailVerificationRequested>(_onAuthEmailVerificationRequested);
    on<AuthPasswordResetRequested>(_onAuthPasswordResetRequested);
    on<AuthPasswordChangeRequested>(_onAuthPasswordChangeRequested);
    on<AuthUserChanged>(_onAuthUserChanged);
  }

  Future<void> _onAuthInitialized(
    AuthInitialized event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final firebaseUser = _authRepository.currentUser;
      if (firebaseUser != null) {
        final user = await _authRepository.getUserData(firebaseUser.uid);
        if (user != null) {
          emit(AuthAuthenticated(user));
        } else {
          emit(AuthUnauthenticated());
        }
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      LoggerService.error('Błąd podczas inicjalizacji uwierzytelnienia', e);
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onAuthLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    try {
      final firebaseUser = await _authRepository.signInWithEmailAndPassword(
        event.email,
        event.password,
      );
      
      final user = await _authRepository.getUserData(firebaseUser.uid);
      if (user != null) {
        emit(AuthAuthenticated(user));
        LoggerService.info('Użytkownik zalogowany: ${user.email}');
      } else {
        emit(AuthError(LocalizationService.getAuthError('user-data-not-found')));
      }
    } catch (e) {
      LoggerService.error('Błąd logowania', e);
      emit(AuthError(_getErrorMessage(e)));
    }
  }

  Future<void> _onAuthRegisterRequested(
    AuthRegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    try {
      final firebaseUser = await _authRepository.createUserWithEmailAndPassword(
        event.email,
        event.password,
      );
      
      final user = User(
        uid: firebaseUser.uid,
        email: event.email,
        firstName: event.firstName,
        lastName: event.lastName,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      
      await _authRepository.saveUserData(user);
      
      // Automatycznie wyślij email weryfikacyjny
      try {
        await _authRepository.sendEmailVerification();
        LoggerService.info('Email weryfikacyjny został wysłany do: ${event.email}');
      } catch (e) {
        LoggerService.error('Nie udało się wysłać emaila weryfikacyjnego', e);
        // Nie przerywamy procesu rejestracji jeśli email się nie wyśle
      }
      
      emit(AuthAuthenticated(user));
      LoggerService.info('Nowy użytkownik zarejestrowany: ${user.email}');
    } catch (e) {
      LoggerService.error('Błąd rejestracji', e);
      emit(AuthError(_getErrorMessage(e)));
    }
  }

  Future<void> _onAuthLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      await _authRepository.signOut();
      emit(AuthUnauthenticated());
      LoggerService.info('Użytkownik wylogowany');
    } catch (e) {
      LoggerService.error('Błąd wylogowania', e);
      emit(AuthError(_getErrorMessage(e)));
    }
  }

  Future<void> _onAuthGoogleSignInRequested(
    AuthGoogleSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    try {
      final firebaseUser = await _authRepository.signInWithGoogle();
      
      final user = await _authRepository.getUserData(firebaseUser.uid);
      if (user != null) {
        emit(AuthAuthenticated(user));
        LoggerService.info('Użytkownik zalogowany przez Google: ${user.email}');
      } else {
        emit(AuthError(LocalizationService.getAuthError('user-data-not-found')));
      }
    } catch (e) {
      LoggerService.error('Błąd logowania Google', e);
      emit(AuthError(_getErrorMessage(e)));
    }
  }

  Future<void> _onAuthEmailVerificationRequested(
    AuthEmailVerificationRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      await _authRepository.sendEmailVerification();
      // Nie zmieniamy stanu - użytkownik nadal jest zalogowany
      LoggerService.info('Email weryfikacyjny został wysłany');
    } catch (e) {
      LoggerService.error('Błąd wysyłania emaila weryfikacyjnego', e);
      emit(AuthError(_getErrorMessage(e)));
    }
  }

  Future<void> _onAuthPasswordResetRequested(
    AuthPasswordResetRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      await _authRepository.sendPasswordResetEmail(event.email);
      LoggerService.info('Email resetujący hasło został wysłany na: ${event.email}');
      // Możemy emitować sukces, ale nie zmieniamy stanu autoryzacji
    } catch (e) {
      LoggerService.error('Błąd wysyłania emaila resetującego hasło', e);
      emit(AuthError(_getErrorMessage(e)));
    }
  }

  Future<void> _onAuthPasswordChangeRequested(
    AuthPasswordChangeRequested event,
    Emitter<AuthState> emit,
  ) async {
    print('AuthBloc - Otrzymano AuthPasswordChangeRequested');
    emit(AuthLoading());
    
    try {
      print('AuthBloc - Wywołanie changePassword w repository');
      await _authRepository.changePassword(
        event.currentPassword,
        event.newPassword,
      );
      
      print('AuthBloc - Zmiana hasła udana, pobieranie danych użytkownika');
      // Po udanej zmianie hasła, emituj specjalny stan sukcesu
      final currentUser = _authRepository.currentUser;
      if (currentUser != null) {
        final user = await _authRepository.getUserData(currentUser.uid);
        if (user != null) {
          print('AuthBloc - Emitowanie AuthPasswordChangeSuccess');
          emit(AuthPasswordChangeSuccess(user));
          LoggerService.info('Hasło zostało zmienione dla użytkownika: ${user.email}');
          
          // Po krótkim czasie, przywróć normalny stan uwierzytelnienia
          await Future.delayed(const Duration(milliseconds: 100));
          print('AuthBloc - Emitowanie AuthAuthenticated');
          emit(AuthAuthenticated(user));
        }
      }
    } catch (e) {
      print('AuthBloc - Błąd zmiany hasła: $e');
      LoggerService.error('Błąd zmiany hasła', e);
      emit(AuthError(_getErrorMessage(e)));
    }
  }

  Future<void> _onAuthUserChanged(
    AuthUserChanged event,
    Emitter<AuthState> emit,
  ) async {
    if (event.firebaseUser != null) {
      try {
        final user = await _authRepository.getUserData(event.firebaseUser!.uid);
        if (user != null) {
          emit(AuthAuthenticated(user));
        } else {
          emit(AuthUnauthenticated());
        }
      } catch (e) {
        LoggerService.error('Błąd podczas ładowania danych użytkownika', e);
        emit(AuthUnauthenticated());
      }
    } else {
      emit(AuthUnauthenticated());
    }
  }

  String _getErrorMessage(dynamic error) {
    if (error is firebase_auth.FirebaseAuthException) {
      return LocalizationService.getAuthError(error.code);
    }
    return LocalizationService.getUnexpectedError();
  }
}
