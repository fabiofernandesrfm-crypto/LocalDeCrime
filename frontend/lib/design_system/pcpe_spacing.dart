/// Sistema de espaçamento PCPE.
///
/// Baseado em incrementos de 4px (8pt grid system),
/// garantindo ritmo visual consistente em toda a aplicação.
class PCPESpacing {
  PCPESpacing._();

  /// 4px  – mínimo
  static const double xs = 4;

  /// 8px  – pequeno
  static const double sm = 8;

  /// 12px – médio-pequeno
  static const double mdSm = 12;

  /// 16px – médio
  static const double md = 16;

  /// 20px – médio-grande
  static const double mdLg = 20;

  /// 24px – grande
  static const double lg = 24;

  /// 28px – extra-grande
  static const double xl = 28;

  /// 32px – 2xl
  static const double xxl = 32;

  /// 40px – 3xl
  static const double xxxl = 40;

  /// 48px – 4xl
  static const double huge = 48;

  /// 56px – gigante
  static const double giant = 56;

  /// Padding padrão de tela (horizontal)
  static const double screenHorizontal = 16;

  /// Padding padrão de tela (vertical)
  static const double screenVertical = 8;

  /// Padding interno de cards
  static const double cardInner = 20;

  /// Altura padrão de input
  static const double inputHeight = 48;

  /// Altura pequena de input/button
  static const double controlSmall = 38;

  /// Largura do navigation rail
  static const double railWidth = 72;

  /// Largura do drawer
  static const double drawerWidth = 280;
}