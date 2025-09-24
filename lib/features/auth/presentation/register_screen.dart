import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../logic/auth_bloc.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/loading_overlay.dart';
import '../../../core/services/logger_service.dart';
import '../../../core/utils/password_validator.dart';
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
  
  // Stan wskaźników wymagań hasła
  bool _hasMinLength = false;
  bool _hasDigit = false;
  bool _hasUppercase = false;
  bool _hasSpecialChar = false;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_checkPasswordRequirements);
  }

  void _checkPasswordRequirements() {
    final password = _passwordController.text;
    setState(() {
      _hasMinLength = PasswordValidator.hasMinLength(password);
      _hasDigit = PasswordValidator.hasDigit(password);
      _hasUppercase = PasswordValidator.hasUppercase(password);
      _hasSpecialChar = PasswordValidator.hasSpecialChar(password);
    });
  }

  @override
  void dispose() {
    _passwordController.removeListener(_checkPasswordRequirements);
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
                    autovalidateMode: AutovalidateMode.onUserInteraction,
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
                          labelText: AppLocalizations.of(context)!.lastName,
                          hintText: AppLocalizations.of(context)!.enterLastName,
                          prefixIcon: Icons.person_outlined,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AppLocalizations.of(context)!.pleaseEnterLastName;
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
                          labelText: AppLocalizations.of(context)!.emailAddress,
                          hintText: AppLocalizations.of(context)!.enterEmail,
                          keyboardType: TextInputType.emailAddress,
                          prefixIcon: Icons.email_outlined,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AppLocalizations.of(context)!.pleaseEnterEmail;
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
                            final localizations = AppLocalizations.of(context)!;
                            return PasswordValidator.validatePasswordGeneral(
                              value,
                              requiredMessage: localizations.passwordRequiredMessage,
                              allRequirementsMustBeMetMessage: localizations.passwordAllRequirementsMustBeMet,
                            );
                          },
                        ),
                        const SizedBox(height: 8),
                        
                        // Wskaźnik wymagań hasła
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.passwordRequirements,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              _buildRequirementRow(
                                AppLocalizations.of(context)!.passwordMinLengthMessage,
                                _hasMinLength,
                              ),
                              _buildRequirementRow(
                                AppLocalizations.of(context)!.passwordDigitRequiredMessage,
                                _hasDigit,
                              ),
                              _buildRequirementRow(
                                AppLocalizations.of(context)!.passwordUppercaseRequiredMessage,
                                _hasUppercase,
                              ),
                              _buildRequirementRow(
                                AppLocalizations.of(context)!.passwordSpecialCharRequiredMessage,
                                _hasSpecialChar,
                              ),
                            ],
                          ),
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
                        
                        // Divider "LUB"
                        Row(
                          children: [
                            const Expanded(child: Divider()),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                localizations.or.toUpperCase(),
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                            const Expanded(child: Divider()),
                          ],
                        ),
                        const SizedBox(height: 16),
                        
                        // Google Sign-In Button
                        OutlinedButton.icon(
                          onPressed: () {
                            context.read<AuthBloc>().add(AuthGoogleSignInRequested());
                          },
                          icon: Image.asset(
                            'assets/icons/google.png',
                            height: 20,
                            width: 20,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.g_mobiledata, size: 20);
                            },
                          ),
                          label: Text(localizations.continueWithGoogle),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: BorderSide(color: Colors.grey[300]!),
                          ),
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

  Widget _buildRequirementRow(String requirement, bool isMet) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(
            isMet ? Icons.check_circle : Icons.radio_button_unchecked,
            size: 16,
            color: isMet 
                ? Colors.green 
                : Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              requirement,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: isMet 
                    ? Colors.green 
                    : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
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
