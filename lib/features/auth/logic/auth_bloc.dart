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
