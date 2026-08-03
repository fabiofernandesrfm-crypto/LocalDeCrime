import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../../design_system/design_system.dart';

/// Estado da gravação de áudio.
enum AudioRecorderState {
  idle,
  recording,
  paused,
}

/// Widget reutilizável para gravação de áudio (mock).
///
/// Armazena o áudio apenas em memória. Não envia para servidor.
/// A interface permanece desacoplada para futura integração com backend.
///
/// Uso:
/// ```dart
/// AudioRecorderWidget(
///   onRecordingComplete: (audioData) {
///     // audioData contém dados mock do áudio
///   },
/// )
/// ```
class AudioRecorderWidget extends StatefulWidget {
  /// Callback chamado ao finalizar a gravação.
  /// Recebe os dados mock do áudio (nome, duração, tamanho).
  final void Function(AudioRecordingData data)? onRecordingComplete;

  /// Callback chamado ao cancelar a gravação.
  final VoidCallback? onRecordingCancelled;

  const AudioRecorderWidget({
    super.key,
    this.onRecordingComplete,
    this.onRecordingCancelled,
  });

  @override
  State<AudioRecorderWidget> createState() => _AudioRecorderWidgetState();
}

/// Dados mock de uma gravação de áudio.
class AudioRecordingData {
  final String fileName;
  final Duration duration;
  final int fileSizeBytes;
  final DateTime recordedAt;

  const AudioRecordingData({
    required this.fileName,
    required this.duration,
    required this.fileSizeBytes,
    required this.recordedAt,
  });

  String get formattedDuration {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  String get formattedFileSize {
    if (fileSizeBytes < 1024) return '$fileSizeBytes B';
    if (fileSizeBytes < 1024 * 1024) {
      return '${(fileSizeBytes / 1024).toStringAsFixed(1)} KB';
    }
    return '${(fileSizeBytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}

class _AudioRecorderWidgetState extends State<AudioRecorderWidget> {
  AudioRecorderState _state = AudioRecorderState.idle;
  Timer? _timer;
  Duration _elapsed = Duration.zero;
  DateTime? _recordingStartTime;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startRecording() {
    setState(() {
      _state = AudioRecorderState.recording;
      _elapsed = Duration.zero;
      _recordingStartTime = DateTime.now();
    });
    _startTimer();
  }

  void _pauseRecording() {
    _timer?.cancel();
    setState(() {
      _state = AudioRecorderState.paused;
    });
  }

  void _resumeRecording() {
    setState(() {
      _state = AudioRecorderState.recording;
    });
    _startTimer();
  }

  void _stopRecording() {
    _timer?.cancel();
    final duration = _elapsed;
    final startTime = _recordingStartTime ?? DateTime.now();

    // Gera dados mock
    final random = Random();
    final fileSizeBytes = (duration.inSeconds * 16 * 1000) + random.nextInt(50000); // ~16KB/s
    final fileName =
        'audio_${startTime.year}${startTime.month.toString().padLeft(2, '0')}'
        '${startTime.day.toString().padLeft(2, '0')}_'
        '${startTime.hour.toString().padLeft(2, '0')}'
        '${startTime.minute.toString().padLeft(2, '0')}'
        '${startTime.second.toString().padLeft(2, '0')}.wav';

    final data = AudioRecordingData(
      fileName: fileName,
      duration: duration,
      fileSizeBytes: fileSizeBytes,
      recordedAt: startTime,
    );

    setState(() {
      _state = AudioRecorderState.idle;
      _elapsed = Duration.zero;
    });

    widget.onRecordingComplete?.call(data);
  }

  void _cancelRecording() {
    _timer?.cancel();
    setState(() {
      _state = AudioRecorderState.idle;
      _elapsed = Duration.zero;
    });
    widget.onRecordingCancelled?.call();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted && _state == AudioRecorderState.recording) {
        setState(() {
          _elapsed = _elapsed + const Duration(seconds: 1);
        });
      }
    });
  }

  String get _formattedElapsed {
    final minutes = _elapsed.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = _elapsed.inSeconds.remainder(60).toString().padLeft(2, '0');
    final hours = _elapsed.inHours.toString().padLeft(2, '0');
    if (_elapsed.inHours > 0) {
      return '$hours:$minutes:$seconds';
    }
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Cronômetro / timer em tempo real
        if (_state != AudioRecorderState.idle) _buildTimerDisplay(),
        const SizedBox(height: 12),
        // Botões de controle
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _buildControlButtons(),
        ),
      ],
    );
  }

  Widget _buildTimerDisplay() {
    final isRecording = _state == AudioRecorderState.recording;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isRecording ? PCPEColors.errorLight : PCPEColors.warningLight,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: (isRecording ? PCPEColors.error : PCPEColors.warning)
              .withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        children: [
          if (isRecording) _RecordingPulseIndicator(),
          Icon(
            isRecording ? Icons.fiber_manual_record : Icons.pause_circle_filled,
            color: isRecording ? PCPEColors.error : PCPEColors.warning,
            size: 16,
          ),
          const SizedBox(width: 10),
          Text(
            isRecording ? _formattedElapsed : 'Pausado - $_formattedElapsed',
            style: TextStyle(
              color: PCPEColors.black,
              fontWeight: FontWeight.w600,
              fontSize: 18,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildControlButtons() {
    switch (_state) {
      case AudioRecorderState.idle:
        return [
          _ControlButton(
            icon: Icons.mic,
            label: 'Gravar Áudio',
            color: PCPEColors.error,
            onPressed: _startRecording,
          ),
        ];
      case AudioRecorderState.recording:
        return [
          _ControlButton(
            icon: Icons.pause,
            label: 'Pausar',
            color: PCPEColors.warning,
            onPressed: _pauseRecording,
          ),
          _ControlButton(
            icon: Icons.stop,
            label: 'Finalizar',
            color: PCPEColors.primary,
            onPressed: _stopRecording,
          ),
          _ControlButton(
            icon: Icons.close,
            label: 'Cancelar',
            color: PCPEColors.mediumGray,
            onPressed: _cancelRecording,
          ),
        ];
      case AudioRecorderState.paused:
        return [
          _ControlButton(
            icon: Icons.mic,
            label: 'Continuar',
            color: PCPEColors.error,
            onPressed: _resumeRecording,
          ),
          _ControlButton(
            icon: Icons.stop,
            label: 'Finalizar',
            color: PCPEColors.primary,
            onPressed: _stopRecording,
          ),
          _ControlButton(
            icon: Icons.close,
            label: 'Cancelar',
            color: PCPEColors.mediumGray,
            onPressed: _cancelRecording,
          ),
        ];
    }
  }
}

/// Botão de controle estilizado.
class _ControlButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onPressed;

  const _ControlButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
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

/// Indicador de pulso para gravação ativa.
class _RecordingPulseIndicator extends StatefulWidget {
  @override
  State<_RecordingPulseIndicator> createState() =>
      _RecordingPulseIndicatorState();
}

class _RecordingPulseIndicatorState extends State<_RecordingPulseIndicator>
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
        return Container(
          width: 14,
          height: 14,
          margin: const EdgeInsets.only(right: 6),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: PCPEColors.error.withValues(
              alpha: 0.5 + (_animController.value * 0.5),
            ),
          ),
        );
      },
    );
  }
}