import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Niestandardowe animacje przejść między stronami
class PageTransitions {
  /// Przejście ze slajdem w prawo (powrót)
  static Page<T> slideRightTransition<T extends Object?>(
    BuildContext context,
    GoRouterState state,
    Widget child,
  ) {
    return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.fastOutSlowIn;

        var tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );

        // Efekt wychodzenia - ekran ucieka w lewo
        var exitTween = Tween(begin: Offset.zero, end: const Offset(-1.0, 0.0)).chain(
          CurveTween(curve: curve),
        );

        return SlideTransition(
          position: animation.drive(tween),
          child: SlideTransition(
            position: secondaryAnimation.drive(exitTween),
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
      reverseTransitionDuration: const Duration(milliseconds: 300),
    );
  }

  /// Przejście ze slajdem w lewo (nawigacja do przodu)
  static Page<T> slideLeftTransition<T extends Object?>(
    BuildContext context,
    GoRouterState state,
    Widget child,
  ) {
    return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(-1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.fastOutSlowIn;

        var tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );

        // Efekt wychodzenia - ekran ucieka w prawo
        var exitTween = Tween(begin: Offset.zero, end: const Offset(1.0, 0.0)).chain(
          CurveTween(curve: curve),
        );

        return SlideTransition(
          position: animation.drive(tween),
          child: SlideTransition(
            position: secondaryAnimation.drive(exitTween),
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
      reverseTransitionDuration: const Duration(milliseconds: 300),
    );
  }

  /// Przejście typu fade dla głównej nawigacji
  static Page<T> fadeTransition<T extends Object?>(
    BuildContext context,
    GoRouterState state,
    Widget child,
  ) {
    return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 200),
      reverseTransitionDuration: const Duration(milliseconds: 200),
    );
  }

  /// Przejście ze skalowaniem (dla akcji typu dodawanie)
  static Page<T> scaleTransition<T extends Object?>(
    BuildContext context,
    GoRouterState state,
    Widget child,
  ) {
    return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const curve = Curves.fastOutSlowIn;
        
        var scaleTween = Tween<double>(
          begin: 0.8,
          end: 1.0,
        ).chain(CurveTween(curve: curve));
        
        var opacityTween = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).chain(CurveTween(curve: curve));

        // Efekt wychodzenia - ekran się zmniejsza i znika
        var exitScaleTween = Tween<double>(
          begin: 1.0,
          end: 0.8,
        ).chain(CurveTween(curve: curve));
        
        var exitOpacityTween = Tween<double>(
          begin: 1.0,
          end: 0.0,
        ).chain(CurveTween(curve: curve));

        return ScaleTransition(
          scale: animation.drive(scaleTween),
          child: FadeTransition(
            opacity: animation.drive(opacityTween),
            child: ScaleTransition(
              scale: secondaryAnimation.drive(exitScaleTween),
              child: FadeTransition(
                opacity: secondaryAnimation.drive(exitOpacityTween),
                child: child,
              ),
            ),
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 350),
      reverseTransitionDuration: const Duration(milliseconds: 250),
    );
  }

  /// Przejście ze slajdem z dołu (dla modali/dodawania)
  static Page<T> slideUpTransition<T extends Object?>(
    BuildContext context,
    GoRouterState state,
    Widget child,
  ) {
    return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.fastOutSlowIn;

        var tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );

        // Efekt wychodzenia - ekran ucieka w dół
        var exitTween = Tween(begin: Offset.zero, end: const Offset(0.0, 1.0)).chain(
          CurveTween(curve: curve),
        );

        return SlideTransition(
          position: animation.drive(tween),
          child: SlideTransition(
            position: secondaryAnimation.drive(exitTween),
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 400),
      reverseTransitionDuration: const Duration(milliseconds: 300),
    );
  }

  /// Przejście kombinowane (slide + fade) dla szczegółowych widoków
  static Page<T> slideAndFadeTransition<T extends Object?>(
    BuildContext context,
    GoRouterState state,
    Widget child,
  ) {
    return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.3, 0.0);
        const end = Offset.zero;
        const curve = Curves.fastOutSlowIn;

        var slideTween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );
        
        var fadeTween = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).chain(CurveTween(curve: curve));

        // Efekt wychodzenia - ekran ucieka w prawo z fade
        var exitSlideTween = Tween(begin: Offset.zero, end: const Offset(0.3, 0.0)).chain(
          CurveTween(curve: curve),
        );
        
        var exitFadeTween = Tween<double>(
          begin: 1.0,
          end: 0.0,
        ).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(slideTween),
          child: FadeTransition(
            opacity: animation.drive(fadeTween),
            child: SlideTransition(
              position: secondaryAnimation.drive(exitSlideTween),
              child: FadeTransition(
                opacity: secondaryAnimation.drive(exitFadeTween),
                child: child,
              ),
            ),
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 350),
      reverseTransitionDuration: const Duration(milliseconds: 250),
    );
  }

  /// Przejście kierunkowe dla nawigacji głównej (prawo/lewo w zależności od kierunku)
  static Page<T> navigationTransition<T extends Object?>(
    BuildContext context,
    GoRouterState state,
    Widget child, {
    required bool slideLeft, // true = slide left (wchodzi z lewej), false = slide right (wchodzi z prawej)
  }) {
    return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final begin = slideLeft ? const Offset(-1.0, 0.0) : const Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.fastOutSlowIn;

        var tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );

        // Efekt wychodzenia - poprzedni ekran ucieka w przeciwnym kierunku
        final exitOffset = slideLeft ? const Offset(1.0, 0.0) : const Offset(-1.0, 0.0);
        var exitTween = Tween(begin: Offset.zero, end: exitOffset).chain(
          CurveTween(curve: curve),
        );

        return SlideTransition(
          position: animation.drive(tween),
          child: SlideTransition(
            position: secondaryAnimation.drive(exitTween),
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
      reverseTransitionDuration: const Duration(milliseconds: 300),
    );
  }
}
