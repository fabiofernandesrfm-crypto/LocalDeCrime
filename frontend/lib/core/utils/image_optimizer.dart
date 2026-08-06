import 'dart:typed_data';
import 'dart:math' as math;

/// Utilitário para otimização de imagens no frontend.
///
/// Responsável por reduzir resolução e aplicar compressão
/// mantendo boa qualidade visual, visando compatibilidade
/// futura com PDF institucional e integração SPP.
class ImageOptimizer {
  /// Dimensões máximas recomendadas para fotos em relatório PDF/SPP.
  static const int _maxWidth = 1920;
  static const int _maxHeight = 1920;

  /// Qualidade de compressão JPEG (0-100).
  /// 85 oferece excelente relação qualidade/tamanho.
  static const int _jpegQuality = 85;

  /// Calcula dimensões otimizadas mantendo aspect ratio.
  static ({int width, int height}) calcularDimensoes({
    required int originalWidth,
    required int originalHeight,
    int maxWidth = _maxWidth,
    int maxHeight = _maxHeight,
  }) {
    if (originalWidth <= maxWidth && originalHeight <= maxHeight) {
      return (width: originalWidth, height: originalHeight);
    }

    final ratio = math.min(
      maxWidth / originalWidth,
      maxHeight / originalHeight,
    );

    return (
      width: (originalWidth * ratio).round(),
      height: (originalHeight * ratio).round(),
    );
  }

  /// Aplica otimização aos bytes da imagem.
  ///
  /// Atualmente retorna os bytes originais (placeholder).
  /// Na implementação real, utilizaria pacotes como `image` ou
  /// `flutter_image_compress` para redimensionar e comprimir.
  static Future<Uint8List> otimizarBytes(
    Uint8List bytes, {
    int maxWidth = _maxWidth,
    int maxHeight = _maxHeight,
    int quality = _jpegQuality,
  }) async {
    // Placeholder: retorna bytes originais.
    // Futuramente:
    // 1. Decodificar imagem
    // 2. Redimensionar para dimensões máximas
    // 3. Comprimir com qualidade configurada
    // 4. Retornar bytes otimizados
    return bytes;
  }

  /// Estima o tamanho após otimização (em KB).
  ///
  /// Estimativa conservadora baseada em compressão JPEG Q85.
  static double estimarTamanhoOtimizadoKB({
    required int originalWidth,
    required int originalHeight,
  }) {
    final dims = calcularDimensoes(
      originalWidth: originalWidth,
      originalHeight: originalHeight,
    );
    // Estimativa: ~0.15 bytes/pixel para JPEG Q85
    final estimatedBytes = dims.width * dims.height * 0.15;
    return estimatedBytes / 1024.0;
  }
}