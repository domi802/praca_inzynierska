import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../logic/auth_bloc.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/loading_overlay.dart';
import '../../../core/services/logger_service.dart';
import '../../../l10n/app_localizations.dart';

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
    final localizations = AppLocalizations.of(context)!;
    LoggerService.info('RegisterScreen zbudowany - ekran rejestracji jest aktywny');
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.register),
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
                          AppLocalizations.of(context)!.createNewAccount,
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          AppLocalizations.of(context)!.fillFormToCreateAccount,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),
                        
                        // Imię
                        CustomTextField(
                          controller: _firstNameController,
                          labelText: AppLocalizations.of(context)!.firstName,
                          hintText: AppLocalizations.of(context)!.enterFirstName,
                          prefixIcon: Icons.person_outlined,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AppLocalizations.of(context)!.provideFirstName;
                            }
                            if (value.length < 2) {
                              return AppLocalizations.of(context)!.firstNameMinLength;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        
                        // Nazwisko
                        CustomTextField(
                          controller: _lastNameController,
                          labelText: 'Nazwisko',
                          hintText: AppLocalizations.of(context)!.enterLastName,
                          prefixIcon: Icons.person_outlined,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Podaj nazwisko';
                            }
                            if (value.length < 2) {
                              return AppLocalizations.of(context)!.lastNameMinLength;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        
                        // Email
                        CustomTextField(
                          controller: _emailController,
                          labelText: 'Adres email',
                          hintText: AppLocalizations.of(context)!.enterEmail,
                          keyboardType: TextInputType.emailAddress,
                          prefixIcon: Icons.email_outlined,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Podaj adres email';
                            }
                            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                              return AppLocalizations.of(context)!.provideValidEmail;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        
                        // Hasło
                        CustomTextField(
                          controller: _passwordController,
                          labelText: AppLocalizations.of(context)!.password,
                          hintText: AppLocalizations.of(context)!.enterPassword,
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
                              return AppLocalizations.of(context)!.providePassword;
                            }
                            if (value.length < 6) {
                              return AppLocalizations.of(context)!.passwordMinLength;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        
                        // Powtórz hasło
                        CustomTextField(
                          controller: _confirmPasswordController,
                          labelText: AppLocalizations.of(context)!.confirmPassword,
                          hintText: AppLocalizations.of(context)!.enterPasswordAgain,
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
                              return AppLocalizations.of(context)!.repeatPasswordField;
                            }
                            if (value != _passwordController.text) {
                              return AppLocalizations.of(context)!.passwordsNotMatch;
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
                          child: Text(localizations.register),
                        ),
                        const SizedBox(height: 16),
                        
                        // Link do logowania
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.alreadyHaveAccountQuestion,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            TextButton(
                              onPressed: () => context.go('/login'),
                              child: Text(localizations.login),
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
