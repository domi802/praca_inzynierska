import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import '../../features/auth/logic/auth_bloc.dart';
import '../../l10n/app_localizations.dart';

/// Banner informujący o potrzebie weryfikacji email
class EmailVerificationBanner extends StatefulWidget {
  const EmailVerificationBanner({Key? key}) : super(key: key);

  @override
  State<EmailVerificationBanner> createState() => _EmailVerificationBannerState();
}

class _EmailVerificationBannerState extends State<EmailVerificationBanner> {
  bool _isDismissed = false;

  @override
  Widget build(BuildContext context) {
    final user = firebase_auth.FirebaseAuth.instance.currentUser;
    final l10n = AppLocalizations.of(context)!;
    
    // Ukryj banner jeśli:
    // - użytkownik nie jest zalogowany
    // - email jest zweryfikowany
    // - banner został ukryty przez użytkownika
    if (user == null || user.emailVerified || _isDismissed) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.orange[900]!.withOpacity(0.3) // Ciemny pomarańczowy w dark mode
            : Colors.amber[50], // Jasny amber w light mode
        border: Border.all(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.orange[600]! // Pomarańczowa ramka w dark mode
              : Colors.amber[300]!, // Amber ramka w light mode
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.orange[800]!.withOpacity(0.4) // Ciemny pomarańczowy w dark mode
                    : Colors.amber[100], // Jasny amber w light mode
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.email_outlined,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.orange[300] // Jasny pomarańczowy w dark mode
                    : Colors.amber[800], // Ciemny amber w light mode
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    l10n.verifyYourEmail,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.orange[200] // Jasny pomarańczowy w dark mode
                          : Colors.amber[900], // Ciemny amber w light mode
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    l10n.checkEmailForVerification,
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.orange[300] // Jasny pomarańczowy w dark mode
                          : Colors.amber[700], // Amber w light mode
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Przycisk odświeżenia
            IconButton(
              onPressed: () async {
                // Odśwież stan użytkownika
                await user.reload();
                final updatedUser = firebase_auth.FirebaseAuth.instance.currentUser;
                if (updatedUser?.emailVerified == true && mounted) {
                  setState(() {
                    // Banner zniknie automatycznie przez warunek powyżej
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.emailVerified),
                      backgroundColor: Colors.green,
                      duration: const Duration(seconds: 3),
                    ),
                  );
                }
              },
              icon: Icon(
                Icons.refresh,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.orange[300] // Jasny pomarańczowy w dark mode
                    : Colors.amber[700], // Amber w light mode
                size: 20,
              ),
              tooltip: l10n.checkVerification,
            ),
            // Przycisk wyślij ponownie
            TextButton(
              onPressed: () {
                context.read<AuthBloc>().add(AuthEmailVerificationRequested());
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(l10n.emailVerificationSent),
                    backgroundColor: Theme.of(context).brightness == Brightness.dark
                        ? Colors.orange[700] // Ciemny pomarańczowy w dark mode
                        : Colors.amber[700], // Amber w light mode
                    duration: const Duration(seconds: 3),
                  ),
                );
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                minimumSize: Size.zero,
              ),
              child: Text(
                l10n.resendEmail,
                style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.orange[300] // Jasny pomarańczowy w dark mode
                      : Colors.amber[800], // Ciemny amber w light mode
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ),
            // Przycisk ukrycia
            IconButton(
              onPressed: () {
                setState(() {
                  _isDismissed = true;
                });
              },
              icon: Icon(
                Icons.close,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.orange[400] // Jasny pomarańczowy w dark mode
                    : Colors.amber[600], // Amber w light mode
                size: 18,
              ),
              tooltip: l10n.hide,
            ),
          ],
        ),
      ),
    );
  }
}

