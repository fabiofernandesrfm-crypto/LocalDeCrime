import 'package:flutter/material.dart';

/// Sistema de border-radius PCPE.
///
/// Escala consistente para cantos arredondados,
/// variando de 4px (sutil) até 28px (totalmente circular em ícones grandes).
class PCPEBorderRadius {
  PCPEBorderRadius._();

  /// 4px  – inputs, checkboxes
  static const double xs = 4;

  /// 8px  – chips, badges pequenos
  static const double sm = 8;

  /// 10px – botões, inputs padrão, navigation
  static const double md = 10;

  /// 12px – avatares pequenos, ícones em containers
  static const double mdLg = 12;

  /// 14px – cards, FAB, containers principais
  static const double lg = 14;

  /// 18px – cards de login, diálogos
  static const double xl = 18;

  /// 20px – chips arredondados, tags
  static const double xxl = 20;

  /// 24px – avatares médios, ícones de splash
  static const double huge = 24;

  /// 28px – avatares grandes (splash screen)
  static const double giant = 28;

  // ── Circular shortcuts ──────────────────────────────────────
  static const BorderRadius card = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius dialog = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius button = BorderRadius.all(Radius.circular(md));
  static const BorderRadius input = BorderRadius.all(Radius.circular(md));
  static const BorderRadius chip = BorderRadius.all(Radius.circular(xxl));
  static const BorderRadius avatar = BorderRadius.all(Radius.circular(mdLg));
  static const BorderRadius fab = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius menu = BorderRadius.all(Radius.circular(md));
}