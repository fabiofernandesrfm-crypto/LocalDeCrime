import 'package:flutter/material.dart';
import '../../design_system/design_system.dart';
import '../models/media_item.dart';
import 'pcpe_card.dart';
import 'pcpe_section_title.dart';
import 'pcpe_button.dart';
import 'media_thumbnail_card.dart';
import 'media_preview_screen.dart';
import 'camera_capture_widget.dart';

/// Seção reutilizável de captura de imagens para incorporação
/// em qualquer etapa do wizard (Local, Pessoas, Veículos, Objetos, Vestígios).
///
/// Suporta:
/// - Capturar foto (câmera mock)
/// - Selecionar da galeria (mock)
/// - Visualizar miniaturas
/// - Remover imagem
/// - Visualizar imagem ampliada
class MediaCaptureSection extends StatefulWidget {
  final List<MediaItem> midias;
  final void Function() onChanged;
  final String title;
  final IconData icon;
  final String? subtitle;
  final String gpsTexto;

  const MediaCaptureSection({
    super.key,
    required this.midias,
    required this.onChanged,
    this.title = 'Fotografias',
    this.icon = Icons.photo_camera_outlined,
    this.subtitle,
    this.gpsTexto = 'GPS não disponível',
  });

  @override
  State<MediaCaptureSection> createState() => _MediaCaptureSectionState();
}

class _MediaCaptureSectionState extends State<MediaCaptureSection> {
  int _mediaId = 0;

  int get _nextId => _mediaId++;

  void _addMedia(MediaItem item) {
    setState(() {
      widget.midias.add(item);
      widget.onChanged();
    });
  }

  void _removeMedia(int index) {
    setState(() {
      widget.midias.removeAt(index);
      widget.onChanged();
    });
  }

  Future<void> _tirarFoto() async {
    final item = await CameraCaptureWidget.tirarFoto(
      context,
      nextId: _nextId,
      gps: widget.gpsTexto,
    );
    if (item != null) _addMedia(item);
  }

  Future<void> _selecionarFoto() async {
    final item = await CameraCaptureWidget.selecionarFoto(
      context,
      nextId: _nextId,
      gps: widget.gpsTexto,
    );
    if (item != null) _addMedia(item);
  }

  void _openPreview(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MediaPreviewScreen(
          item: widget.midias[index],
          allItems: widget.midias,
          initialIndex: index,
        ),
      ),
    );
  }

  void _editarLegenda(int index) {
    final item = widget.midias[index];
    final legendaCtrl = TextEditingController(text: item.legenda);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
          decoration: const BoxDecoration(
            color: PCPEColors.pureWhite,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: PCPEColors.lightGray,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Row(
                children: [
                  Icon(item.tipoIcon, color: item.placeholderColor, size: 24),
                  const SizedBox(width: 10),
                  const Text(
                    'Editar Legenda',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: PCPEColors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: legendaCtrl,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: 'Legenda da foto',
                  hintText: 'Descreva o conteúdo...',
                  filled: true,
                  fillColor: PCPEColors.cardGray,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: PCPEColors.lightGray.withValues(alpha: 0.5),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: PCPEColors.primary),
                  ),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: PCPEButton(
                      label: 'Cancelar',
                      outlined: true,
                      fullWidth: true,
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: PCPEButton(
                      label: 'Salvar',
                      icon: Icons.save,
                      fullWidth: true,
                      onPressed: () {
                        setState(() {
                          widget.midias[index].legenda = legendaCtrl.text;
                          widget.onChanged();
                        });
                        Navigator.pop(ctx);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalItems = widget.midias.length;

    return PCPECard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: PCPESectionTitle(
                  title: widget.title,
                  icon: widget.icon,
                  subtitle: widget.subtitle,
                ),
              ),
              if (totalItems > 0)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: PCPEColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$totalItems foto(s)',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: PCPEColors.primary,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 14),
          // Botões de ação de captura
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _ActionChip(
                icon: Icons.camera_alt,
                label: 'Tirar Foto',
                color: PCPEColors.info,
                onTap: _tirarFoto,
              ),
              _ActionChip(
                icon: Icons.photo_library,
                label: 'Selecionar Foto',
                color: const Color(0xFF1565C0),
                onTap: _selecionarFoto,
              ),
            ],
          ),
          // Galeria de miniaturas
          if (totalItems > 0) ...[
            const SizedBox(height: 14),
            LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                int crossAxisCount;
                if (width >= 600) {
                  crossAxisCount = 4;
                } else if (width >= 400) {
                  crossAxisCount = 3;
                } else {
                  crossAxisCount = 2;
                }
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: width >= 600 ? 0.8 : 0.85,
                  ),
                  itemCount: totalItems,
                  itemBuilder: (context, index) {
                    final item = widget.midias[index];
                    return MediaThumbnailCard(
                      item: item,
                      onTap: () => _openPreview(index),
                      onDelete: () => _removeMedia(index),
                      onEdit: () => _editarLegenda(index),
                    );
                  },
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}

/// Chip de ação estilizado para captura/seleção de mídia.
class _ActionChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionChip({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: color.withValues(alpha: 0.25)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18, color: color),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}