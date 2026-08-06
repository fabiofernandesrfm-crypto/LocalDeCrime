import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

enum PCPEStatus {
  ativo,
  concluido,
  pendente,
  emAndamento,
  cancelado,
  urgente,
  arquivado,
  rascunho,
  enviadoSpp,
}

extension PCPEStatusExtension on PCPEStatus {
  String get label {
    switch (this) {
      case PCPEStatus.ativo:
        return 'Ativo';
      case PCPEStatus.concluido:
        return 'Concluído';
      case PCPEStatus.pendente:
        return 'Pendente';
      case PCPEStatus.emAndamento:
        return 'Em Andamento';
      case PCPEStatus.cancelado:
        return 'Cancelado';
      case PCPEStatus.urgente:
        return 'Urgente';
      case PCPEStatus.arquivado:
        return 'Arquivado';
      case PCPEStatus.rascunho:
        return 'Rascunho';
      case PCPEStatus.enviadoSpp:
        return 'Enviado ao SPP';
    }
  }

  Color get color {
    switch (this) {
      case PCPEStatus.ativo:
        return PCPEColors.success;
      case PCPEStatus.concluido:
        return PCPEColors.info;
      case PCPEStatus.pendente:
        return PCPEColors.warning;
      case PCPEStatus.emAndamento:
        return PCPEColors.primary;
      case PCPEStatus.cancelado:
        return PCPEColors.error;
      case PCPEStatus.urgente:
        return PCPEColors.error;
      case PCPEStatus.arquivado:
        return PCPEColors.mediumGray;
      case PCPEStatus.rascunho:
        return PCPEColors.mediumGray;
      case PCPEStatus.enviadoSpp:
        return PCPEColors.success;
    }
  }

  Color get backgroundColor {
    switch (this) {
      case PCPEStatus.ativo:
        return PCPEColors.successLight;
      case PCPEStatus.concluido:
        return PCPEColors.infoLight;
      case PCPEStatus.pendente:
        return PCPEColors.warningLight;
      case PCPEStatus.emAndamento:
        return PCPEColors.primarySoft;
      case PCPEStatus.cancelado:
        return PCPEColors.errorLight;
      case PCPEStatus.urgente:
        return PCPEColors.errorLight;
      case PCPEStatus.arquivado:
        return PCPEColors.cardGray;
      case PCPEStatus.rascunho:
        return PCPEColors.surfaceGray;
      case PCPEStatus.enviadoSpp:
        return PCPEColors.successLight;
    }
  }

  IconData get icon {
    switch (this) {
      case PCPEStatus.ativo:
        return Icons.check_circle;
      case PCPEStatus.concluido:
        return Icons.task_alt;
      case PCPEStatus.pendente:
        return Icons.pending;
      case PCPEStatus.emAndamento:
        return Icons.play_circle;
      case PCPEStatus.cancelado:
        return Icons.cancel;
      case PCPEStatus.urgente:
        return Icons.priority_high;
      case PCPEStatus.arquivado:
        return Icons.archive;
      case PCPEStatus.rascunho:
        return Icons.edit_note;
      case PCPEStatus.enviadoSpp:
        return Icons.send;
    }
  }
}

class PCPEStatusChip extends StatelessWidget {
  final PCPEStatus status;
  final bool showIcon;
  final bool filled;

  const PCPEStatusChip({
    super.key,
    required this.status,
    this.showIcon = true,
    this.filled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: filled ? status.color.withValues(alpha: 0.12) : status.backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: status.color.withValues(alpha: 0.4), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIcon) ...[
            Icon(status.icon, size: 14, color: status.color),
            const SizedBox(width: 4),
          ],
          Text(
            status.label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: status.color,
            ),
          ),
        ],
      ),
    );
  }
}