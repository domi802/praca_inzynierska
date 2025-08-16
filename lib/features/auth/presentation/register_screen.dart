import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../logic/auth_bloc.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/loading_overlay.dart';
import '../../../core/services/logger_service.dart';

/// Ekran rejestracji nowego użytkownika
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    LoggerService.info('RegisterScreen zbudowany - ekran rejestracji jest aktywny');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rejestracja'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/login'),
        ),
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is AuthAuthenticated) {
            context.go('/');
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            return LoadingOverlay(
              isLoading: state is AuthLoading,
              child: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Nagłówek
                        Text(
                          'Utwórz nowe konto',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Wypełnij formularz aby założyć konto',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),
                        
                        // Imię
                        CustomTextField(
                          controller: _firstNameController,
                          labelText: 'Imię',
                          hintText: 'Wprowadź swoje imię',
                          prefixIcon: Icons.person_outlined,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Podaj imię';
                            }
                            if (value.length < 2) {
                              return 'Imię musi mieć co najmniej 2 znaki';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        
                        // Nazwisko
                        CustomTextField(
                          controller: _lastNameController,
                          labelText: 'Nazwisko',
                          hintText: 'Wprowadź swoje nazwisko',
                          prefixIcon: Icons.person_outlined,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Podaj nazwisko';
                            }
                            if (value.length < 2) {
                              return 'Nazwisko musi mieć co najmniej 2 znaki';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        
                        // Email
                        CustomTextField(
                          controller: _emailController,
                          labelText: 'Adres email',
                          hintText: 'Wprowadź swój email',
                          keyboardType: TextInputType.emailAddress,
                          prefixIcon: Icons.email_outlined,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Podaj adres email';
                            }
                            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                              return 'Podaj prawidłowy adres email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        
                        // Hasło
                        CustomTextField(
                          controller: _passwordController,
                          labelText: 'Hasło',
                          hintText: 'Wprowadź hasło (min. 6 znaków)',
                          obscureText: _obscurePassword,
                          prefixIcon: Icons.lock_outlined,
                          suffixIcon: _obscurePassword 
                              ? Icons.visibility_outlined 
                              : Icons.visibility_off_outlined,
                          onSuffixIconTap: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Podaj hasło';
                            }
                            if (value.length < 6) {
                              return 'Hasło musi mieć co najmniej 6 znaków';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        
                        // Powtórz hasło
                        CustomTextField(
                          controller: _confirmPasswordController,
                          labelText: 'Powtórz hasło',
                          hintText: 'Wprowadź hasło ponownie',
                          obscureText: _obscureConfirmPassword,
                          prefixIcon: Icons.lock_outlined,
                          suffixIcon: _obscureConfirmPassword 
                              ? Icons.visibility_outlined 
                              : Icons.visibility_off_outlined,
                          onSuffixIconTap: () {
                            setState(() {
                              _obscureConfirmPassword = !_obscureConfirmPassword;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Powtórz hasło';
                            }
                            if (value != _passwordController.text) {
                              return 'Hasła nie są identyczne';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 32),
                        
                        // Przycisk rejestracji
                        ElevatedButton(
                          onPressed: _register,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text('Zarejestruj się'),
                        ),
                        const SizedBox(height: 16),
                        
                        // Link do logowania
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Masz już konto? ',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            TextButton(
                              onPressed: () => context.go('/login'),
                              child: const Text('Zaloguj się'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _register() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
        AuthRegisterRequested(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
        ),
      );
    }
  }
}
