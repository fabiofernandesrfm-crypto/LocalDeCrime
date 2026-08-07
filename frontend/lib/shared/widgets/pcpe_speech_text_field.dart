import 'package:flutter/material.dart';
import 'speech_to_text_widget.dart';
import '../../design_system/design_system.dart';
import 'pcpe_button.dart';

/// Componente reutilizavel: Campo de texto com suporte a digitacao e ditado.
///
/// Segue o principio: AUTOMATIZAR → SUGERIR → DITAR → DIGITAR
/// NUNCA sobrescreve texto existente. NUNCA armazena audio.
class PCPESpeechTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final IconData? prefixIcon;
  final int maxLines;
  final VoidCallback? onChanged;

  const PCPESpeechTextField({
    super.key,
    required this.controller,
    this.label = '',
    this.hint,
    this.prefixIcon,
    this.maxLines = 4,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      if (label.isNotEmpty) ...[
        Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: PCPEColors.darkGray)),
        const SizedBox(height: 6),
      ],
      Container(
        decoration: BoxDecoration(border: Border.all(color: PCPEColors.lightGray.withValues(alpha: 0.5)), borderRadius: BorderRadius.circular(10)),
        child: Column(children: [
          TextField(
            controller: controller,
            maxLines: maxLines,
            onChanged: (_) => onChanged?.call(),
            decoration: InputDecoration(
              hintText: hint,
              prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: PCPEColors.mediumGray) : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              fillColor: PCPEColors.cardGray,
              filled: true,
            ),
            style: const TextStyle(fontSize: 13, color: PCPEColors.darkGray),
          ),
          Container(
            decoration: BoxDecoration(border: Border(top: BorderSide(color: PCPEColors.lightGray.withValues(alpha: 0.3)))),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(children: [
              Expanded(child: PCPEButton(label: '✏ Digitar', icon: Icons.keyboard, outlined: true, small: true, height: 30, onPressed: () { FocusScope.of(context).requestFocus(FocusNode()); })),
              const SizedBox(width: 8),
              Expanded(child: SpeechToTextWidget(controller: controller, onChanged: onChanged)),
            ]),
          ),
        ]),
      ),
    ]);
  }
}