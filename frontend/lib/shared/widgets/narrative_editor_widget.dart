import 'package:flutter/material.dart';
import '../../design_system/design_system.dart';
import 'speech_to_text_widget.dart';
import 'audio_recorder_widget.dart';
import 'audio_player_widget.dart';

/// Modos de entrada da narrativa.
enum NarrativeInputMode {
  /// Digitação manual (editor de texto).
  typing,

  /// Ditado por voz (Speech-to-Text).
  speech,

  /// Gravação de áudio.
  audio,
}

/// Widget principal para edição multimodal da narrativa.
///
/// Oferece três modos de entrada:
/// 1. ✍ Digitação manual
/// 2. 🎤 Ditado por voz
/// 3. 🎙 Gravação de áudio
///
/// O usuário pode alternar livremente entre os modos
/// através da barra de seleção superior.
///
/// Interface desacoplada para futura integração com backend.
class NarrativeEditorWidget extends StatefulWidget {
  /// Controlador do texto da narrativa (modo digitação e ditado).
  final TextEditingController textController;

  /// Título da seção de narrativa.
  final String title;

  /// Subtítulo / descrição.
  final String subtitle;

  /// Ícone da seção.
  final IconData icon;

  /// Dica do campo de texto.
  final String hint;

  /// Máximo de linhas do editor de texto.
  final int maxLines;

  /// Callback chamado quando o texto é alterado.
  final VoidCallback? onChanged;

  const NarrativeEditorWidget({
    super.key,
    required this.textController,
    this.title = 'Narrativa do Fato',
    this.subtitle = 'Descreva detalhadamente a dinâmica do evento',
    this.icon = Icons.edit_note,
    this.hint = 'Descreva detalhadamente os fatos ocorridos...',
    this.maxLines = 12,
    this.onChanged,
  });

  @override
  State<NarrativeEditorWidget> createState() => _NarrativeEditorWidgetState();
}

class _NarrativeEditorWidgetState extends State<NarrativeEditorWidget> {
  NarrativeInputMode _currentMode = NarrativeInputMode.typing;

  /// Lista de áudios gravados (mock, apenas em memória).
  final List<AudioRecordingData> _audioRecordings = [];

  /// Controlador específico para o modo ditado, sincronizado
  /// com o controlador principal.
  late TextEditingController _speechController;

  @override
  void initState() {
    super.initState();
    _speechController = widget.textController;
  }

  void _onRecordingComplete(AudioRecordingData data) {
    setState(() {
      _audioRecordings.add(data);
    });
  }

  void _removeAudio(int index) {
    setState(() {
      _audioRecordings.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Detecta largura para responsividade
    final screenWidth = MediaQuery.of(context).size.width;
    final isCompact = screenWidth < 600;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Barra de seleção de modo
        _buildModeSelector(isCompact),
        const SizedBox(height: 16),
        // Conteúdo do modo selecionado
        _buildModeContent(),
        // Lista de áudios gravados (visível em todos os modos)
        if (_audioRecordings.isNotEmpty) ...[
          const SizedBox(height: 16),
          _buildAudioRecordingsList(),
        ],
      ],
    );
  }

  /// Barra superior com os 3 modos: ✍ Digitar | 🎤 Ditado | 🎙 Áudio
  Widget _buildModeSelector(bool isCompact) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: PCPEColors.cardGray,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: PCPEColors.lightGray.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          _ModeTab(
            icon: Icons.edit,
            label: isCompact ? 'Digitar' : '✍ Digitar',
            isSelected: _currentMode == NarrativeInputMode.typing,
            onTap: () => setState(() => _currentMode = NarrativeInputMode.typing),
          ),
          _ModeTab(
            icon: Icons.mic,
            label: isCompact ? 'Ditado' : '🎤 Ditado',
            isSelected: _currentMode == NarrativeInputMode.speech,
            onTap: () => setState(() => _currentMode = NarrativeInputMode.speech),
          ),
          _ModeTab(
            icon: Icons.multitrack_audio,
            label: isCompact ? 'Áudio' : '🎙 Áudio',
            isSelected: _currentMode == NarrativeInputMode.audio,
            onTap: () => setState(() => _currentMode = NarrativeInputMode.audio),
          ),
        ],
      ),
    );
  }

  Widget _buildModeContent() {
    switch (_currentMode) {
      case NarrativeInputMode.typing:
        return _buildTypingMode();
      case NarrativeInputMode.speech:
        return _buildSpeechMode();
      case NarrativeInputMode.audio:
        return _buildAudioMode();
    }
  }

  /// Modo 1: Digitação manual.
  Widget _buildTypingMode() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: widget.textController,
          maxLines: widget.maxLines,
          minLines: 5,
          onChanged: (_) => widget.onChanged?.call(),
          decoration: InputDecoration(
            hintText: widget.hint,
            hintMaxLines: 3,
            hintStyle: TextStyle(color: PCPEColors.mediumGray, fontSize: 13),
            prefixIcon: Padding(
              padding: const EdgeInsets.only(bottom: 80),
              child:
                  Icon(Icons.description_outlined, color: PCPEColors.mediumGray),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: PCPEColors.lightGray),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: PCPEColors.lightGray),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide:
                  BorderSide(color: PCPEColors.primary, width: 1.5),
            ),
            filled: true,
            fillColor: PCPEColors.cardGray,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
          style: TextStyle(
            fontSize: 14,
            color: PCPEColors.black,
            height: 1.6,
          ),
        ),
      ],
    );
  }

  /// Modo 2: Ditado por voz.
  Widget _buildSpeechMode() {
    return SpeechToTextWidget(
      controller: _speechController,
      onChanged: widget.onChanged,
    );
  }

  /// Modo 3: Gravação de áudio.
  Widget _buildAudioMode() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: PCPEColors.infoLight,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
                color: PCPEColors.lightGray.withValues(alpha: 0.5)),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline, color: PCPEColors.info, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'O áudio será armazenado apenas no dispositivo '
                  'até o envio da ocorrência.',
                  style: TextStyle(
                    fontSize: 12,
                    color: PCPEColors.darkGray,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        AudioRecorderWidget(
          onRecordingComplete: _onRecordingComplete,
          onRecordingCancelled: () {
            // Nada a fazer, o gravador volta ao estado idle
          },
        ),
      ],
    );
  }

  /// Lista de gravações de áudio realizadas.
  Widget _buildAudioRecordingsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Gravações (${_audioRecordings.length})',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: PCPEColors.darkGray,
          ),
        ),
        const SizedBox(height: 8),
        ...List.generate(_audioRecordings.length, (index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: AudioPlayerWidget(
              audioData: _audioRecordings[index],
              onDelete: () => _removeAudio(index),
            ),
          );
        }),
      ],
    );
  }
}

/// Aba individual do seletor de modo.
class _ModeTab extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ModeTab({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          decoration: BoxDecoration(
            color: isSelected ? PCPEColors.pureWhite : Colors.transparent,
            borderRadius: BorderRadius.circular(7),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 16,
                color: isSelected ? PCPEColors.primary : PCPEColors.mediumGray,
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected ? PCPEColors.black : PCPEColors.mediumGray,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}