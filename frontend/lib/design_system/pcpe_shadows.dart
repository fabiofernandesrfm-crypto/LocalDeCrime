import 'package:flutter/material.dart';
import 'pcpe_colors.dart';

/// Sistema de sombras PCPE.
///
/// Sombras consistentes para cards, botões, dialogs e outros
/// componentes, mantendo profundidade visual padronizada.
class PCPEShadows {
  PCPEShadows._();

  // ── Elevation Levels ───────────────────────────────────────

  /// Sombra sutil – inputs, cards plain
  static List<BoxShadow> get subtle => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.04),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ];

  /// Sombra padrão – cards, containers principais
  static List<BoxShadow> get card => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.06),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ];

  /// Sombra média – dialogs, popups
  static List<BoxShadow> get medium => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.08),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
      ];

  /// Sombra elevada – FAB, bottom nav, drawer
  static List<BoxShadow> get elevated => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.1),
          blurRadius: 20,
          offset: const Offset(0, 6),
        ),
      ];

  /// Sombra flutuante – tooltips, dropdowns
  static List<BoxShadow> get floating => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.12),
          blurRadius: 28,
          offset: const Offset(0, 8),
        ),
      ];

  // ── Specialized ─────────────────────────────────────────────

  /// Sombra para cards de login/autenticação
  static List<BoxShadow> get auth => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.06),
          blurRadius: 24,
          offset: const Offset(0, 6),
        ),
      ];

  /// Sombra para o header do side menu (efeito de profundidade)
  static List<BoxShadow> get sideMenuHeader => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.15),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ];

  /// Sombra para o bottom navigation bar
  static List<BoxShadow> get bottomNav => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.08),
          blurRadius: 12,
          offset: const Offset(0, -2),
        ),
      ];

  /// Sombra para botão primário
  static List<BoxShadow> get primaryButton => [
        BoxShadow(
          color: PCPEColors.primary.withValues(alpha: 0.2),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ];

  /// Sombra para botão FAB
  static List<BoxShadow> get fab => [
        BoxShadow(
          color: PCPEColors.primary.withValues(alpha: 0.3),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ];
}