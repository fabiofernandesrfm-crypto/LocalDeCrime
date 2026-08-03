import 'dart:async';
import 'package:flutter/material.dart';
import '../../design_system/design_system.dart';
import '../models/media_item.dart';

/// Modal de captura de mídia (mock).
///
/// Simula a interface de câmera para foto e vídeo.
/// Não utiliza câmera real — gera dados mock simulando
/// o fluxo de captura e confirmação.
class CameraCaptureWidget {
  /// Abre o modal de captura de foto (mock).
  /// Retorna o [MediaItem] criado ou null se cancelado.
  static Future<MediaItem?> tirarFoto(
    BuildContext context, {
    required int nextId,
    String gps = '',
  }) async {
    return _showCaptureDialog(
      context,
      mode: _CaptureMode.photo,
      nextId: nextId,
      gps: gps,
    );
  }

  /// Abre o modal de captura de vídeo (mock).
  /// Retorna o [MediaItem] criado ou null se cancelado.
  static Future<MediaItem?> gravarVideo(
    BuildContext context, {
    required int nextId,
    String gps = '',
  }) async {
    return _showCaptureDialog(
      context,
      mode: _CaptureMode.video,
      nextId: nextId,
      gps: gps,
    );
  }

  /// Abre o modal de seleção de foto da galeria (mock).
  /// Retorna o [MediaItem] criado ou null se cancelado.
  static Future<MediaItem?> selecionarFoto(
    BuildContext context, {
    required int nextId,
    String gps = '',
  }) async {
    // Simula delay de seleção
    await Future.delayed(const Duration(milliseconds: 600));
    if (!context.mounted) return null;
    return MediaItem.foto(
      id: nextId,
      legenda: 'Foto da galeria',
      gps: gps,
    );
  }

  /// Abre o modal de seleção de vídeo da galeria (mock).
  /// Retorna o [MediaItem] criado ou null se cancelado.
  static Future<MediaItem?> selecionarVideo(
    BuildContext context, {
    required int nextId,
    String gps = '',
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));
    if (!context.mounted) return null;
    return MediaItem.video(
      id: nextId,
      legenda: 'Vídeo da galeria',
      gps: gps,
    );
  }

  // ── Diálogo de captura ───────────────────────────────────────

  static Future<MediaItem?> _showCaptureDialog(
    BuildContext context, {
    required _CaptureMode mode,
    required int nextId,
    String gps = '',
  }) async {
    return showDialog<MediaItem>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => _CaptureDialog(
        mode: mode,
        nextId: nextId,
        gps: gps,
      ),
    );
  }
}

enum _CaptureMode { photo, video }

class _CaptureDialog extends StatefulWidget {
  final _CaptureMode mode;
  final int nextId;
  final String gps;

  const _CaptureDialog({
    required this.mode,
    required this.nextId,
    required this.gps,
  });

  @override
  State<_CaptureDialog> createState() => _CaptureDialogState();
}

class _CaptureDialogState extends State<_CaptureDialog> {
  bool _captured = false;
  bool _countingDown = false;
  int _countdown = 3;
  Timer? _timer;
  Timer? _recordTimer;
  Duration _recordElapsed = Duration.zero;
  bool _isRecording = false;

  @override
  void dispose() {
    _timer?.cancel();
    _recordTimer?.cancel();
    super.dispose();
  }

  bool get _isPhoto => widget.mode == _CaptureMode.photo;
  bool get _isVideo => widget.mode == _CaptureMode.video;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.black,
      insetPadding: EdgeInsets.zero,
      child: Stack(
        children: [
          // ── Viewfinder / Preview simulados ──────────────────
          Column(
            children: [
              Expanded(
                child: _buildViewfinder(),
              ),
              _buildBottomBar(),
            ],
          ),
          // ── Botão fechar ────────────────────────────────────
          Positioned(
            top: 12,
            left: 12,
            child: SafeArea(
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 28),
                onPressed: () => Navigator.pop(context),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.black38,
                ),
              ),
            ),
          ),
          // ── Contador regressivo ──────────────────────────────
          if (_countingDown)
            Center(
              child: Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '$_countdown',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          // ── Tela de confirmação ─────────────────────────────
          if (_captured && _isPhoto) _buildPhotoConfirmation(),
          if (_captured && _isVideo) _buildVideoConfirmation(),
        ],
      ),
    );
  }

  // ── Viewfinder simulada ──────────────────────────────────────

  Widget _buildViewfinder() {
    return Container(
      decoration: BoxDecoration(
        color: (_isVideo && _isRecording)
            ? PCPEColors.error.withValues(alpha: 0.05)
            : Colors.black,
      ),
      child: Stack(
        children: [
          // Placeholder da câmera
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _isPhoto ? Icons.camera_alt : Icons.videocam,
                  size: 80,
                  color: Colors.white24,
                ),
                const SizedBox(height: 16),
                Text(
                  _isPhoto ? 'Câmera — Modo Foto' : 'Câmera — Modo Vídeo',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.4),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Simulação de câmera • Mock',
                    style: TextStyle(color: Colors.white30, fontSize: 11),
                  ),
                ),
              ],
            ),
          ),
          // Grid de câmera
          CustomPaint(
            size: Size.infinite,
            painter: _CameraGridPainter(),
          ),
          // Indicador de gravação
          if (_isVideo && _isRecording)
            Positioned(
              top: 16,
              right: 16,
              child: _RecordingIndicator(),
            ),
          // Timer de gravação
          if (_isVideo && _isRecording)
            Positioned(
              top: 16,
              left: 50,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: PCPEColors.error,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  _formattedRecordElapsed,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ── Bottom bar com botões de controle ────────────────────────

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      color: const Color(0xFF141414),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (_isPhoto) ...[
              // ── Foto: botão de captura ─────────────────────
              const SizedBox(width: 48), // placeholder alinhamento
              GestureDetector(
                onTap: _handlePhotoCapture,
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 4),
                    color: Colors.white.withValues(alpha: 0.2),
                  ),
                  child: Center(
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 48),
            ] else ...[
              // ── Vídeo: botão de iniciar/parar gravação ─━━
              IconButton(
                icon: Icon(
                  Icons.flip_camera_android,
                  color: Colors.white.withValues(alpha: 0.6),
                ),
                onPressed: () {},
              ),
              GestureDetector(
                onTap: _isRecording ? _stopVideoRecording : _startVideoRecording,
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _isRecording ? PCPEColors.error : Colors.white,
                      width: 4,
                    ),
                  ),
                  child: Center(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: _isRecording ? 28 : 56,
                      height: _isRecording ? 28 : 56,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _isRecording ? PCPEColors.error : Colors.white,
                        borderRadius: _isRecording
                            ? BorderRadius.circular(4)
                            : null,
                      ),
                    ),
                  ),
                ),
              ),
              // Botão de confirmar/parar (quando já gravou)
              if (_captured)
                IconButton(
                  icon: const Icon(Icons.check, color: PCPEColors.success, size: 32),
                  onPressed: () => _confirmCapture(),
                )
              else
                const SizedBox(width: 48),
            ],
          ],
        ),
      ),
    );
  }

  // ── Confirmação de foto ──────────────────────────────────────

  Widget _buildPhotoConfirmation() {
    return Positioned(
      bottom: 100,
      left: 0,
      right: 0,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Foto capturada!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Imagem adicionada à galeria',
              style: TextStyle(color: Colors.white54, fontSize: 13),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _confirmButton(
                  icon: Icons.refresh,
                  label: 'Refazer',
                  onTap: () => setState(() => _captured = false),
                  color: Colors.white24,
                ),
                _confirmButton(
                  icon: Icons.check,
                  label: 'Usar foto',
                  onTap: () => _confirmCapture(),
                  color: PCPEColors.success,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ── Confirmação de vídeo ─────────────────────────────────────

  Widget _buildVideoConfirmation() {
    return Positioned(
      bottom: 100,
      left: 0,
      right: 0,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Vídeo finalizado!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Duração: $_formattedRecordElapsed',
              style: const TextStyle(color: Colors.white54, fontSize: 14),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _confirmButton(
                  icon: Icons.refresh,
                  label: 'Refazer',
                  onTap: () => setState(() {
                    _captured = false;
                    _recordElapsed = Duration.zero;
                  }),
                  color: Colors.white24,
                ),
                _confirmButton(
                  icon: Icons.check,
                  label: 'Usar vídeo',
                  onTap: () => _confirmCapture(),
                  color: PCPEColors.success,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _confirmButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required Color color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withValues(alpha: 0.4)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(color: color, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  // ── Lógica de captura (mock) ─────────────────────────────────

  void _handlePhotoCapture() {
    setState(() => _countingDown = true);
    _countdown = 3;

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_countdown <= 1) {
        t.cancel();
        setState(() {
          _countingDown = false;
          _captured = true;
        });
        return;
      }
      setState(() => _countdown--);
    });
  }

  void _startVideoRecording() {
    setState(() {
      _isRecording = true;
      _captured = false;
      _recordElapsed = Duration.zero;
    });

    _recordTimer?.cancel();
    _recordTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (mounted && _isRecording) {
        setState(() {
          _recordElapsed += const Duration(seconds: 1);
        });
        // Auto-stop após 60s (simulação)
        if (_recordElapsed.inSeconds >= 60) {
          _stopVideoRecording();
        }
      }
    });
  }

  void _stopVideoRecording() {
    _recordTimer?.cancel();
    setState(() {
      _isRecording = false;
      _captured = true;
    });
  }

  void _confirmCapture() {
    final now = DateTime.now();
    final item = _isPhoto
        ? MediaItem.foto(
            id: widget.nextId,
            legenda: _isPhoto ? 'Foto capturada' : '',
            data: now,
            gps: widget.gps,
          )
        : MediaItem.video(
            id: widget.nextId,
            legenda: 'Vídeo gravado',
            data: now,
            gps: widget.gps,
            duracao: _recordElapsed,
          );

    Navigator.pop(context, item);
  }

  String get _formattedRecordElapsed {
    final m = _recordElapsed.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = _recordElapsed.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }
}

// ── Grid de câmera ─────────────────────────────────────────────

class _CameraGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.08)
      ..strokeWidth = 0.5;

    // Linha horizontal central
    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width, size.height / 2),
      paint,
    );

    // Linha vertical central
    canvas.drawLine(
      Offset(size.width / 2, 0),
      Offset(size.width / 2, size.height),
      paint,
    );

    // Linhas de terço
    final thirdH = size.height / 3;
    final thirdW = size.width / 3;
    final paintThin = Paint()
      ..color = Colors.white.withValues(alpha: 0.04)
      ..strokeWidth = 0.5;

    canvas.drawLine(Offset(0, thirdH), Offset(size.width, thirdH), paintThin);
    canvas.drawLine(Offset(0, thirdH * 2), Offset(size.width, thirdH * 2), paintThin);
    canvas.drawLine(Offset(thirdW, 0), Offset(thirdW, size.height), paintThin);
    canvas.drawLine(Offset(thirdW * 2, 0), Offset(thirdW * 2, size.height), paintThin);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ── Indicador de gravação pulsante ─────────────────────────────

class _RecordingIndicator extends StatefulWidget {
  @override
  State<_RecordingIndicator> createState() => _RecordingIndicatorState();
}

class _RecordingIndicatorState extends State<_RecordingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animController,
      builder: (context, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: PCPEColors.error.withValues(
                  alpha: 0.5 + (_animController.value * 0.5),
                ),
              ),
            ),
            const SizedBox(width: 6),
            const Text(
              'REC',
              style: TextStyle(
                color: PCPEColors.error,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
              ),
            ),
          ],
        );
      },
    );
  }
}