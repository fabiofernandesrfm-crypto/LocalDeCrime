import 'dart:async';
import 'package:flutter/material.dart';
import '../../design_system/design_system.dart';
import 'audio_recorder_widget.dart';

/// Estado da reprodução de áudio.
enum AudioPlayerState {
  stopped,
  playing,
  paused,
}

/// Widget reutilizável para reprodução de áudio (mock).
///
/// Exibe player com controles (play, pause, stop),
/// tempo gravado e nome do arquivo.
///
/// Todo o áudio é mantido em memória (mock).
/// Interface desacoplada para futura integração com backend.
class AudioPlayerWidget extends StatefulWidget {
  /// Dados do áudio a ser reproduzido.
  final AudioRecordingData audioData;

  /// Callback chamado ao remover o áudio.
  final VoidCallback? onDelete;

  const AudioPlayerWidget({
    super.key,
    required this.audioData,
    this.onDelete,
  });

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  AudioPlayerState _playerState = AudioPlayerState.stopped;
  Timer? _timer;
  Duration _currentPosition = Duration.zero;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _play() {
    setState(() {
      _playerState = AudioPlayerState.playing;
    });
    _startProgressTimer();
  }

  void _pause() {
    _timer?.cancel();
    setState(() {
      _playerState = AudioPlayerState.paused;
    });
  }

  void _stop() {
    _timer?.cancel();
    setState(() {
      _playerState = AudioPlayerState.stopped;
      _currentPosition = Duration.zero;
    });
  }

  void _startProgressTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted || _playerState != AudioPlayerState.playing) {
        timer.cancel();
        return;
      }

      setState(() {
        _currentPosition = _currentPosition + const Duration(seconds: 1);
        if (_currentPosition >= widget.audioData.duration) {
          _currentPosition = widget.audioData.duration;
          _playerState = AudioPlayerState.stopped;
          timer.cancel();
        }
      });
    });
  }

  String _formatDuration(Duration duration) {
    final minutes =
        duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds =
        duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  double get _progress {
    if (widget.audioData.duration.inSeconds == 0) return 0;
    return _currentPosition.inSeconds /
        widget.audioData.duration.inSeconds;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: PCPEColors.cardGray,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: PCPEColors.lightGray.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header: ícone + nome do arquivo + botão de remover
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: PCPEColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.audiotrack,
                  color: PCPEColors.primary,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.audioData.fileName,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: PCPEColors.black,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${widget.audioData.formattedDuration} • '
                      '${widget.audioData.formattedFileSize}',
                      style: TextStyle(
                        fontSize: 11,
                        color: PCPEColors.mediumGray,
                      ),
                    ),
                  ],
                ),
              ),
              if (widget.onDelete != null)
                IconButton(
                  onPressed: widget.onDelete,
                  icon: Icon(
                    Icons.delete_outline,
                    color: PCPEColors.mediumGray,
                    size: 20,
                  ),
                  visualDensity: VisualDensity.compact,
                  splashRadius: 20,
                ),
            ],
          ),
          const SizedBox(height: 12),
          // Barra de progresso
          Row(
            children: [
              Text(
                _formatDuration(_currentPosition),
                style: TextStyle(
                  fontSize: 11,
                  fontFamily: 'monospace',
                  color: PCPEColors.darkGray,
                ),
              ),
              Expanded(
                child: SliderTheme(
                  data: SliderThemeData(
                    trackHeight: 4,
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                    activeTrackColor: PCPEColors.primary,
                    inactiveTrackColor: PCPEColors.lightGray,
                    thumbColor: PCPEColors.primary,
                    overlayColor: PCPEColors.primary.withValues(alpha: 0.1),
                  ),
                  child: Slider(
                    value: _progress.clamp(0.0, 1.0),
                    onChanged: (value) {
                      setState(() {
                        _currentPosition = Duration(
                          seconds:
                              (value * widget.audioData.duration.inSeconds)
                                  .round(),
                        );
                      });
                    },
                  ),
                ),
              ),
              Text(
                _formatDuration(widget.audioData.duration),
                style: TextStyle(
                  fontSize: 11,
                  fontFamily: 'monospace',
                  color: PCPEColors.darkGray,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Controles de reprodução
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _PlayerButton(
                icon: _playerState == AudioPlayerState.playing
                    ? Icons.pause
                    : Icons.play_arrow,
                label: _playerState == AudioPlayerState.playing
                    ? 'Pausar'
                    : 'Reproduzir',
                color: PCPEColors.primary,
                onPressed: _playerState == AudioPlayerState.playing
                    ? _pause
                    : _play,
              ),
              const SizedBox(width: 12),
              _PlayerButton(
                icon: Icons.stop,
                label: 'Parar',
                color: PCPEColors.mediumGray,
                onPressed: _stop,
                outlined: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Botão de controle do player.
class _PlayerButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onPressed;
  final bool outlined;

  const _PlayerButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onPressed,
    this.outlined = false,
  });

  @override
  Widget build(BuildContext context) {
    if (outlined) {
      return OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 18),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          foregroundColor: color,
          side: BorderSide(color: color.withValues(alpha: 0.5)),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    }

    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 1,
      ),
    );
  }
}