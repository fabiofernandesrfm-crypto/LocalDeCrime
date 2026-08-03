import 'package:flutter/material.dart';
import '../../design_system/design_system.dart';

// ── Compatibilidade: re-exporta tokens para código existente ─
// Arquivos que importam de 'core/theme/app_theme.dart'
// continuam com acesso a PCPEColors, PCPEStatus, etc.
export '../../design_system/design_system.dart';

class AppTheme {
  AppTheme._();

  /// Use [PCPETheme.light] do Design System para novos projetos.
  static ThemeData get darkTheme => PCPETheme.dark;

  /// Tema principal — delegado ao Design System.
  static ThemeData get lightTheme => PCPETheme.light;
}