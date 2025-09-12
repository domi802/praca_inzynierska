import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../logic/settings_cubit.dart';
import '../../auth/logic/auth_bloc.dart';
import '../../../l10n/app_localizations.dart';


class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.profile),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, authState) {
          return BlocBuilder<SettingsCubit, SettingsState>(
            builder: (context, settingsState) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Sekcja profilu użytkownika
                    if (authState is AuthAuthenticated) ...[
                      _buildUserProfileSection(context, authState, localizations),
                      const SizedBox(height: 24),
                    ],
                    
                    // Sekcja ustawień aplikacji
                    _buildAppSettingsSection(context, settingsState, localizations),
                    
                    const SizedBox(height: 24),
                    
                    // Sekcja konta
                    if (authState is AuthAuthenticated) ...[
                      _buildAccountSection(context, localizations),
                    ],
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildUserProfileSection(BuildContext context, AuthAuthenticated authState, AppLocalizations localizations) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              localizations.userProfile,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            // Avatar i podstawowe dane
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Theme.of(context).brightness == Brightness.dark
                        ? Border.all(
                            color: Colors.grey.shade600,
                            width: 2,
                          )
                        : null,
                  ),
                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor: Theme.of(context).primaryColor,
                    child: Text(
                      authState.user.initials,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${authState.user.firstName} ${authState.user.lastName}',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        authState.user.email,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    context.go('/profile/edit');
                  },
                  icon: const Icon(Icons.edit),
                  tooltip: localizations.editProfile,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppSettingsSection(BuildContext context, SettingsState settingsState, AppLocalizations localizations) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              localizations.appSettings,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            // Wybór języka
            ListTile(
              leading: const Icon(Icons.language),
              title: Text(localizations.language),
              subtitle: Text(
                settingsState.locale.languageCode == 'pl' ? 'Polski' : 'English',
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                _showLanguageDialog(context, settingsState, localizations);
              },
            ),
            
            const Divider(),
            
            // Wybór motywu
            ListTile(
              leading: const Icon(Icons.brightness_6),
              title: Text(localizations.theme),
              subtitle: Text(
                _getThemeDisplayName(settingsState.themeMode, localizations),
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                _showThemeDialog(context, settingsState, localizations);
              },
            ),
            
          ],
        ),
      ),
    );
  }

  Widget _buildAccountSection(BuildContext context, AppLocalizations localizations) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              localizations.account,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            // Zmiana hasła
            ListTile(
              leading: const Icon(Icons.lock),
              title: Text(localizations.changePassword),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                context.go('/profile/change-password');
              },
            ),
            
            const Divider(),
            
            // Wylogowanie
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: Text(
                localizations.logout,
                style: const TextStyle(color: Colors.red),
              ),
              onTap: () {
                _showLogoutDialog(context, localizations);
              },
            ),
          ],
        ),
      ),
    );
  }

  String _getThemeDisplayName(ThemeMode themeMode, AppLocalizations localizations) {
    switch (themeMode) {
      case ThemeMode.light:
        return localizations.lightTheme;
      case ThemeMode.dark:
        return localizations.darkTheme;
      case ThemeMode.system:
        return localizations.systemTheme;
    }
  }

  void _showLanguageDialog(BuildContext context, SettingsState settingsState, AppLocalizations localizations) {
    String selectedLanguage = settingsState.locale.languageCode;
    
    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(localizations.selectLanguage),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<String>(
                title: const Text('Polski'),
                value: 'pl',
                groupValue: selectedLanguage,
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      selectedLanguage = value;
                    });
                  }
                },
              ),
              RadioListTile<String>(
                title: const Text('English'),
                value: 'en',
                groupValue: selectedLanguage,
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      selectedLanguage = value;
                    });
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                minimumSize: const Size(80, 36),
              ),
              child: Text(localizations.cancel),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                context.read<SettingsCubit>().changeLocale(Locale(selectedLanguage));
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                minimumSize: const Size(100, 36),
              ),
              child: Text(localizations.confirm),
            ),
          ],
        ),
      ),
    );
  }

  void _showThemeDialog(BuildContext context, SettingsState settingsState, AppLocalizations localizations) {
    ThemeMode selectedThemeMode = settingsState.themeMode;
    
    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(localizations.selectTheme),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<ThemeMode>(
                title: Text(localizations.lightTheme),
                value: ThemeMode.light,
                groupValue: selectedThemeMode,
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      selectedThemeMode = value;
                    });
                  }
                },
              ),
              RadioListTile<ThemeMode>(
                title: Text(localizations.darkTheme),
                value: ThemeMode.dark,
                groupValue: selectedThemeMode,
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      selectedThemeMode = value;
                    });
                  }
                },
              ),
              RadioListTile<ThemeMode>(
                title: Text(localizations.systemTheme),
                value: ThemeMode.system,
                groupValue: selectedThemeMode,
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      selectedThemeMode = value;
                    });
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                minimumSize: const Size(80, 36),
              ),
              child: Text(localizations.cancel),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                context.read<SettingsCubit>().changeThemeMode(selectedThemeMode);
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                minimumSize: const Size(100, 36),
              ),
              child: Text(localizations.confirm),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, AppLocalizations localizations) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(localizations.logout),
        content: Text(localizations.confirmLogout),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              minimumSize: const Size(80, 36),
            ),
            child: Text(localizations.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<AuthBloc>().add(AuthLogoutRequested());
              Navigator.of(dialogContext).pop();
              context.go('/login');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              minimumSize: const Size(100, 36),
            ),
            child: Text(localizations.logout),
          ),
        ],
      ),
    );
  }
}
