import 'package:flutter/material.dart';
import '../../design_system/design_system.dart';
import '../models/media_item.dart';

/// Card de miniatura unificado para a galeria de mídias.
///
/// Exibe miniatura (placeholder + ícone), tipo, data/hora,
/// legenda editável, duração (vídeo/áudio), GPS e botões
/// de visualização e remoção.
class MediaThumbnailCard extends StatelessWidget {
  final MediaItem item;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const MediaThumbnailCard({
    super.key,
    required this.item,
    required this.onTap,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: item.placeholderColor.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: item.placeholderColor.withValues(alpha: 0.25),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ── Ícone / placeholder ──────────────────────────
            _buildThumbnail(),
            const SizedBox(height: 6),
            // ── Legenda (editável) ────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: GestureDetector(
                onTap: onEdit,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        item.legenda.isNotEmpty
                            ? item.legenda
                            : 'Sem legenda',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: item.legenda.isNotEmpty
                              ? PCPEColors.black
                              : PCPEColors.mediumGray,
                          fontStyle: item.legenda.isNotEmpty
                              ? FontStyle.normal
                              : FontStyle.italic,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 2),
                    const Icon(Icons.edit, size: 10, color: PCPEColors.mediumGray),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 2),
            // ── Tipo ──────────────────────────────────────────
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: _tipoBgColor(item.type).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(item.tipoIcon, size: 11, color: _tipoBgColor(item.type)),
                  const SizedBox(width: 3),
                  Text(
                    item.tipoLabel,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: _tipoBgColor(item.type),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 2),
            // ── Data / Hora ───────────────────────────────────
            Text(
              '${item.data.day.toString().padLeft(2, '0')}/'
              '${item.data.month.toString().padLeft(2, '0')}/'
              '${item.data.year} ${item.hora}',
              style: const TextStyle(fontSize: 9, color: PCPEColors.mediumGray),
            ),
            // ── Duração (vídeo/áudio) ─────────────────────────
            if (item.duracao != null && item.duracao!.inSeconds > 0) ...[
              const SizedBox(height: 2),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.timer, size: 10, color: PCPEColors.mediumGray),
                  const SizedBox(width: 2),
                  Text(
                    item.duracaoFormatada,
                    style: const TextStyle(fontSize: 10, color: PCPEColors.mediumGray),
                  ),
                ],
              ),
            ],
            // ── GPS ───────────────────────────────────────────
            if (item.gps.isNotEmpty) ...[
              const SizedBox(height: 2),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.location_on, size: 10, color: PCPEColors.info),
                  const SizedBox(width: 2),
                  Flexible(
                    child: Text(
                      item.gps,
                      style: const TextStyle(fontSize: 9, color: PCPEColors.info),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
            const Spacer(),
            // ── Botão remover ─────────────────────────────────
            GestureDetector(
              onTap: onDelete,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 5),
                decoration: BoxDecoration(
                  color: PCPEColors.error.withValues(alpha: 0.1),
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(11),
                  ),
                ),
                child: const Center(
                  child: Icon(Icons.delete, size: 14, color: PCPEColors.error),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThumbnail() {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: item.placeholderColor.withValues(alpha: 0.12),
        shape: BoxShape.circle,
      ),
      child: Icon(
        item.tipoIcon,
        size: 26,
        color: item.placeholderColor,
      ),
    );
  }

  static Color _tipoBgColor(MediaType type) {
    switch (type) {
      case MediaType.photo:
        return PCPEColors.info;
      case MediaType.video:
        return const Color(0xFFEF6C00); // laranja
      case MediaType.audio:
        return PCPEColors.success;
    }
  }
}