import 'package:flutter/material.dart';

/// Sistema de animações PCPE.
///
/// Define durações, curvas e transições padrão para
/// manter a fluidez e consistência em toda a aplicação.
class PCPEAnimations {
  PCPEAnimations._();

  // ── Durations ───────────────────────────────────────────────

  /// Duração rápida: 150ms (hover, feedback tátil)
  static const Duration fast = Duration(milliseconds: 150);

  /// Duração padrão: 200ms (transições simples, mudanças de cor)
  static const Duration normal = Duration(milliseconds: 200);

  /// Duração média: 300ms (expansão de cards, troca de tela)
  static const Duration medium = Duration(milliseconds: 300);

  /// Duração lenta: 500ms (transições de página, modais)
  static const Duration slow = Duration(milliseconds: 500);

  /// Duração de splash: 1800ms (animação de entrada)
  static const Duration splash = Duration(milliseconds: 1800);

  /// Duração de carregamento de splash screen: 3000ms
  static const Duration splashDelay = Duration(seconds: 3);

  // ── Curves ──────────────────────────────────────────────────

  /// Curva padrão para transições suaves
  static const Curve standard = Curves.easeInOut;

  /// Curva de entrada (aceleração suave)
  static const Curve easeOut = Curves.easeOut;

  /// Curva para animações de destaque (elástica)
  static const Curve easeOutBack = Curves.easeOutBack;

  /// Curva para deceleration
  static const Curve decelerate = Curves.decelerate;

  /// Curva para animações rápidas e responsivas
  static const Curve fastOutSlowIn = Curves.fastOutSlowIn;

  // ── Page Transitions ────────────────────────────────────────

  /// Transição de slide da direita para esquerda (navegação forward)
  static SlideTransition slideFromRight(
    Animation<double> animation,
    Widget child,
  ) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0.05, 0),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: animation, curve: standard)),
      child: FadeTransition(
        opacity: Tween<double>(begin: 0, end: 1).animate(
          CurvedAnimation(parent: animation, curve: standard),
        ),
        child: child,
      ),
    );
  }

  /// Fade transition simples
  static FadeTransition fade(
    Animation<double> animation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: animation, curve: standard),
      ),
      child: child,
    );
  }

  // ── Utility Methods ─────────────────────────────────────────

  /// Retorna um [AnimatedContainer] com duração padrão do DS
  static Widget animatedContainer({
    required Widget child,
    Duration? duration,
    Curve? curve,
    Decoration? decoration,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    double? width,
    double? height,
    AlignmentGeometry? alignment,
  }) {
    return AnimatedContainer(
      duration: duration ?? normal,
      curve: curve ?? standard,
      decoration: decoration,
      padding: padding,
      margin: margin,
      width: width,
      height: height,
      alignment: alignment,
      child: child,
    );
  }
}