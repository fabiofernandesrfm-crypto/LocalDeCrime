import 'package:flutter/material.dart';
import '../../design_system/design_system.dart';
import '../models/media_item.dart';

/// Tela de preview em tela cheia para fotos e vídeos.
///
/// Fotos: zoom com InteractiveViewer.
/// Vídeos: player mock com controles (play/pause/seek).
class MediaPreviewScreen extends StatefulWidget {
  final MediaItem item;
  final List<MediaItem> allItems;
  final int initialIndex;

  const MediaPreviewScreen({
    super.key,
    required this.item,
    this.allItems = const [],
    this.initialIndex = 0,
  });

  @override
  State<MediaPreviewScreen> createState() => _MediaPreviewScreenState();
}

class _MediaPreviewScreenState extends State<MediaPreviewScreen> {
  late PageController _pageController;
  late int _currentIndex;

  // ── Mock video state ─────────────────────────────────────────
  bool _isPlaying = false;
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  MediaItem get _currentItem =>
      widget.allItems.isNotEmpty
          ? widget.allItems[_currentIndex]
          : widget.item;

  bool get _hasMultiple => widget.allItems.length > 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _currentItem.tipoLabel,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            if (_currentItem.legenda.isNotEmpty)
              Text(
                _currentItem.legenda,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withValues(alpha: 0.7),
                ),
              ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          // Metadata
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showMediaInfo(context),
            tooltip: 'Informações da mídia',
          ),
        ],
      ),
      body: GestureDetector(
        onVerticalDragEnd: (details) {
          if (details.primaryVelocity != null &&
              details.primaryVelocity!.abs() > 300) {
            Navigator.pop(context);
          }
        },
        child: _hasMultiple
            ? PageView.builder(
                controller: _pageController,
                itemCount: widget.allItems.length,
                onPageChanged: (idx) {
                  setState(() {
                    _currentIndex = idx;
                    _isPlaying = false;
                    _progress = 0.0;
                  });
                },
                itemBuilder: (ctx, idx) =>
                    _buildMediaContent(widget.allItems[idx]),
              )
            : _buildMediaContent(widget.item),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildMediaContent(MediaItem item) {
    switch (item.type) {
      case MediaType.photo:
        return _buildPhotoPreview(item);
      case MediaType.video:
        return _buildVideoPreview(item);
      case MediaType.audio:
        return _buildAudioPreview(item);
    }
  }

  // ── Foto: InteractiveViewer com zoom (placeholder mock) ──────

  Widget _buildPhotoPreview(MediaItem item) {
    return InteractiveViewer(
      minScale: 0.5,
      maxScale: 4.0,
      child: Center(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: item.placeholderColor.withValues(alpha: 0.15),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(40),
                decoration: BoxDecoration(
                  color: item.placeholderColor.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.image,
                  size: 80,
                  color: item.placeholderColor.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                item.fileName ?? 'foto.jpg',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.6),
                  fontSize: 13,
                  fontFamily: 'monospace',
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Arraste para ampliar • Foto placeholder',
                  style: TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Vídeo: player mock com controles ─────────────────────────

  Widget _buildVideoPreview(MediaItem item) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: GestureDetector(
            onTap: _togglePlay,
            child: Container(
              width: double.infinity,
              color: Colors.black,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Placeholder do vídeo
                  Container(
                    decoration: BoxDecoration(
                      color: item.placeholderColor.withValues(alpha: 0.12),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            color: item.placeholderColor.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _isPlaying ? Icons.play_arrow : Icons.videocam,
                            size: 64,
                            color: Colors.white54,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          item.fileName ?? 'video.mp4',
                          style: const TextStyle(
                            color: Colors.white38,
                            fontSize: 12,
                            fontFamily: 'monospace',
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Player Mock • Vídeo placeholder',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.3),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Overlay play/pause
                  if (!_isPlaying)
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.play_arrow,
                        size: 48,
                        color: Colors.white,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        // Barra de controles
        _buildVideoControls(item),
      ],
    );
  }

  Widget _buildVideoControls(MediaItem item) {
    final d = item.duracao ?? Duration.zero;
    final currentPos = Duration(
      milliseconds: (d.inMilliseconds * _progress).round(),
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: const Color(0xFF1A1A1A),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Slider de progresso
          Row(
            children: [
              Text(
                _formatDuration(currentPos),
                style: const TextStyle(color: Colors.white70, fontSize: 11),
              ),
              Expanded(
                child: SliderTheme(
                  data: SliderThemeData(
                    trackHeight: 3,
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                    overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
                    activeTrackColor: PCPEColors.primary,
                    inactiveTrackColor: Colors.white24,
                    thumbColor: PCPEColors.primary,
                  ),
                  child: Slider(
                    value: _progress,
                    onChanged: (v) => setState(() => _progress = v),
                  ),
                ),
              ),
              Text(
                item.duracaoFormatada,
                style: const TextStyle(color: Colors.white70, fontSize: 11),
              ),
            ],
          ),
          const SizedBox(height: 6),
          // Botões de controle
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.replay_10, color: Colors.white70),
                onPressed: () {
                  if (item.duracao != null && item.duracao!.inSeconds > 0) {
                    final step = 10 / item.duracao!.inSeconds;
                    setState(() {
                      _progress = (_progress - step).clamp(0.0, 1.0);
                    });
                  }
                },
                tooltip: 'Retroceder 10s',
              ),
              const SizedBox(width: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(
                    _isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                    size: 32,
                  ),
                  onPressed: _togglePlay,
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.forward_10, color: Colors.white70),
                onPressed: () {
                  if (item.duracao != null && item.duracao!.inSeconds > 0) {
                    final step = 10 / item.duracao!.inSeconds;
                    setState(() {
                      _progress = (_progress + step).clamp(0.0, 1.0);
                    });
                  }
                },
                tooltip: 'Avançar 10s',
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Áudio: player mock simples (já existe AudioPlayerWidget) ─

  Widget _buildAudioPreview(MediaItem item) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(24),
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: PCPEColors.success.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.mic, size: 48, color: PCPEColors.success),
            ),
            const SizedBox(height: 20),
            Text(
              item.fileName ?? 'audio.wav',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
                fontFamily: 'monospace',
              ),
            ),
            const SizedBox(height: 8),
            if (item.duracao != null)
              Text(
                'Duração: ${item.duracaoFormatada}',
                style: const TextStyle(color: Colors.white54, fontSize: 16),
              ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.replay_10, color: Colors.white70),
                  onPressed: () {},
                ),
                const SizedBox(width: 12),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.play_arrow, color: Colors.white, size: 36),
                    onPressed: () {},
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                  icon: const Icon(Icons.forward_10, color: Colors.white70),
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ── Bottom bar (navegação entre itens + contador) ────────────

  Widget? _buildBottomBar() {
    if (!_hasMultiple) return null;

    return Container(
      color: const Color(0xFF1A1A1A),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${_currentIndex + 1} / ${widget.allItems.length}',
              style: const TextStyle(color: Colors.white70, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  // ── Modal de informações da mídia ────────────────────────────

  void _showMediaInfo(BuildContext context) {
    final item = _currentItem;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
          decoration: const BoxDecoration(
            color: PCPEColors.pureWhite,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: PCPEColors.lightGray,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Informações da Mídia',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: PCPEColors.black,
                ),
              ),
              const SizedBox(height: 16),
              _infoRow('Tipo', item.tipoLabel),
              _infoRow('Arquivo', item.fileName ?? '—'),
              if (item.duracao != null)
                _infoRow('Duração', item.duracaoFormatada),
              _infoRow(
                'Data',
                '${item.data.day.toString().padLeft(2, '0')}/'
                '${item.data.month.toString().padLeft(2, '0')}/'
                '${item.data.year}',
              ),
              _infoRow('Hora', item.hora),
              _infoRow('GPS', item.gps.isNotEmpty ? item.gps : 'Não disponível'),
              _infoRow('Legenda', item.legenda.isNotEmpty ? item.legenda : '—'),
            ],
          ),
        );
      },
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: PCPEColors.mediumGray,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 13, color: PCPEColors.black),
            ),
          ),
        ],
      ),
    );
  }

  // ── Helpers ──────────────────────────────────────────────────

  void _togglePlay() {
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  String _formatDuration(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }
}