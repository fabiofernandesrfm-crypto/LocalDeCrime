import 'package:flutter/material.dart';
import '../../design_system/design_system.dart';
import 'speech_to_text_widget.dart';

/// Widget para edição da narrativa com digitação e ditado por voz.
///
/// F13 — Apenas dois modos:
/// 1. ✍ Digitação manual
/// 2. 🎤 Ditado por voz (Speech-to-Text)
///
/// Removida toda funcionalidade de gravação/reprodução de áudio.
class NarrativeEditorWidget extends StatefulWidget {
  final TextEditingController textController;
  final String hint;
  final int maxLines;
  final VoidCallback? onChanged;

  const NarrativeEditorWidget({
    super.key,
    required this.textController,
    this.hint = 'Descreva detalhadamente os fatos ocorridos...',
    this.maxLines = 12,
    this.onChanged,
  });

  @override
  State<NarrativeEditorWidget> createState() => _NarrativeEditorWidgetState();
}

class _NarrativeEditorWidgetState extends State<NarrativeEditorWidget> {
  bool _speechMode = false;

  @override
  Widget build(BuildContext context) {
    final isCompact = MediaQuery.of(context).size.width < 600;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Barra de seleção
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: PCPEColors.cardGray,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
                color: PCPEColors.lightGray.withValues(alpha: 0.4)),
          ),
          child: Row(
            children: [
              _ModeTab(
                icon: Icons.edit,
                label: isCompact ? 'Digitar' : '✍ Digitar',
                isSelected: !_speechMode,
                onTap: () => setState(() => _speechMode = false),
              ),
              _ModeTab(
                icon: Icons.mic,
                label: isCompact ? 'Ditar' : '🎤 Ditar Narrativa',
                isSelected: _speechMode,
                onTap: () => setState(() => _speechMode = true),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        if (_speechMode)
          SpeechToTextWidget(
            controller: widget.textController,
            onChanged: widget.onChanged,
          )
        else
          Column(
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
                  hintStyle: TextStyle(
                      color: PCPEColors.mediumGray, fontSize: 13),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(bottom: 80),
                    child: Icon(Icons.description_outlined,
                        color: PCPEColors.mediumGray),
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
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                ),
                style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: PCPEColors.black),
              ),
              const SizedBox(height: 8),
              Text(
                '${widget.textController.text.length} caracteres',
                style: const TextStyle(
                    fontSize: 11, color: PCPEColors.mediumGray),
              ),
            ],
          ),
      ],
    );
  }
}

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
          duration: PCPEAnimations.fast,
          padding:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
          decoration: BoxDecoration(
            color: isSelected ? PCPEColors.pureWhite : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: isSelected ? PCPEColors.primary : PCPEColors.mediumGray,
              ),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected
                        ? PCPEColors.primary
                        : PCPEColors.mediumGray,
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