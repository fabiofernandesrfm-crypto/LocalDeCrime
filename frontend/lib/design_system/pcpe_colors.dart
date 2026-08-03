import 'package:flutter/material.dart';

/// Paleta de cores institucional da Polícia Civil de Pernambuco.
///
/// Identidade visual preto grafite e dourado institucional,
/// transmitindo elegância, autoridade e sobriedade.
///
/// O dourado é utilizado apenas para:
/// • Botões principais
/// • Ícones ativos
/// • Indicadores
/// • Barra de progresso
/// • Stepper
/// • Cards selecionados
/// • Chips ativos
/// • Menu ativo
class PCPEColors {
  PCPEColors._();

  // ── Primárias (Dourado Institucional) ───────────────────────
  static const Color primary = Color(0xFFC8A74E);
  static const Color primaryDark = Color(0xFFB8943A);
  static const Color primaryLight = Color(0xFFD8B75C);
  static const Color primarySoft = Color(0xFFFDF8ED);

  // ── Neutras ─────────────────────────────────────────────────
  static const Color black = Color(0xFF202020);
  static const Color darkGray = Color(0xFF555555);
  static const Color mediumGray = Color(0xFF8A8A8A);
  static const Color lightGray = Color(0xFFBDBDBD);
  static const Color surfaceGray = Color(0xFFE0E0E0);
  static const Color cardGray = Color(0xFFF5F5F5);
  static const Color white = Color(0xFFFAFAFA);
  static const Color pureWhite = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF5F5F5);

  // ── Destaque (mantido para compatibilidade) ─────────────────
  static const Color gold = Color(0xFFC8A74E);
  static const Color goldLight = Color(0xFFD8B75C);
  static const Color goldDark = Color(0xFFB8943A);

  // ── Semânticas ──────────────────────────────────────────────
  static const Color error = Color(0xFFD32F2F);
  static const Color errorLight = Color(0xFFFFEBEE);
  static const Color success = Color(0xFF2E7D32);
  static const Color successLight = Color(0xFFE8F5E9);
  static const Color warning = Color(0xFFEF6C00);
  static const Color warningLight = Color(0xFFFFF3E0);
  static const Color info = Color(0xFF555555);
  static const Color infoLight = Color(0xFFF5F5F5);
}