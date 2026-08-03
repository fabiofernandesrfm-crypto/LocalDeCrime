import 'package:flutter/material.dart';
import '../../../design_system/design_system.dart';
import '../../../shared/models/media_item.dart';
import '../../../shared/widgets/pcpe_card.dart';
import '../../../shared/widgets/pcpe_button.dart';
import '../../../shared/widgets/pcpe_section_title.dart';
import '../../../shared/widgets/media_thumbnail_card.dart';
import '../../../shared/widgets/media_preview_screen.dart';
import '../../../shared/widgets/camera_capture_widget.dart';
import '../../../shared/widgets/audio_recorder_widget.dart';
import 'ocorrencia_wizard_data.dart';

/// Etapa 7: Fotografias e Mídias
///
/// Galeria unificada com:
/// - 📷 Tirar Foto (câmera mock)
/// - 🖼 Selecionar Foto (galeria mock)
/// - 🎥 Gravar Vídeo (câmera mock)
/// - 📁 Selecionar Vídeo (galeria mock)
/// - 🎤 Gravar Áudio (widget existente)
class Step7Fotografias extends StatefulWidget {
  final OcorrenciaWizardData data;
  final void Function() onChanged;

  const Step7Fotografias({
    super.key,
    required this.data,
    required this.onChanged,
  });

  @override
  State<Step7Fotografias> createState() => _Step7FotografiasState();
}

class _Step7FotografiasState extends State<Step7Fotografias> {
  int _mediaId = 0;

  String get _gpsTexto => widget.data.gpsCapturado
      ? '${widget.data.latitude}, ${widget.data.longitude}'
      : 'GPS não disponível';

  // ── Helpers ──────────────────────────────────────────────────

  int get _nextId => _mediaId++;

  void _addMedia(MediaItem item) {
    setState(() {
      widget.data.midias.add(item);
      widget.onChanged();
    });
  }

  void _removeMedia(int index) {
    setState(() {
      widget.data.midias.removeAt(index);
      widget.onChanged();
    });
  }

  // ── Ações de mídia ───────────────────────────────────────────

  Future<void> _tirarFoto() async {
    final item = await CameraCaptureWidget.tirarFoto(
      context,
      nextId: _nextId,
      gps: _gpsTexto,
    );
    if (item != null) _addMedia(item);
  }

  Future<void> _selecionarFoto() async {
    final item = await CameraCaptureWidget.selecionarFoto(
      context,
      nextId: _nextId,
      gps: _gpsTexto,
    );
    if (item != null) _addMedia(item);
  }

  Future<void> _gravarVideo() async {
    final item = await CameraCaptureWidget.gravarVideo(
      context,
      nextId: _nextId,
      gps: _gpsTexto,
    );
    if (item != null) _addMedia(item);
  }

  Future<void> _selecionarVideo() async {
    final item = await CameraCaptureWidget.selecionarVideo(
      context,
      nextId: _nextId,
      gps: _gpsTexto,
    );
    if (item != null) _addMedia(item);
  }

  // ── Preview ──────────────────────────────────────────────────

  void _openPreview(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MediaPreviewScreen(
          item: widget.data.midias[index],
          allItems: widget.data.midias,
          initialIndex: index,
        ),
      ),
    );
  }

  // ── Editar legenda ───────────────────────────────────────────

  void _editarLegenda(int index) {
    final item = widget.data.midias[index];
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
                  labelText: 'Legenda da mídia',
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
                          widget.data.midias[index].legenda = legendaCtrl.text;
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

  // ── Gravação de áudio (usa AudioRecorderWidget) ──────────────

  void _onAudioRecordingComplete(AudioRecordingData audioData) {
    final item = MediaItem.audio(
      id: _nextId,
      legenda: 'Gravação de áudio',
      data: audioData.recordedAt,
      gps: _gpsTexto,
      duracao: audioData.duration,
      fileName: audioData.fileName,
    );
    _addMedia(item);
  }

  // ── Build ────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final totalItems = widget.data.midias.length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Ações rápidas ──────────────────────────────────
          PCPECard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: PCPESectionTitle(
                        title: 'Fotografias e Mídias',
                        icon: Icons.photo_camera_outlined,
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
                          '$totalItems item(ns)',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: PCPEColors.primary,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                // Grid de botões de ação
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
                    _ActionChip(
                      icon: Icons.videocam,
                      label: 'Gravar Vídeo',
                      color: const Color(0xFFEF6C00),
                      onTap: _gravarVideo,
                    ),
                    _ActionChip(
                      icon: Icons.video_library,
                      label: 'Selecionar Vídeo',
                      color: const Color(0xFFC62828),
                      onTap: _selecionarVideo,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Gravação de áudio
                AudioRecorderWidget(
                  onRecordingComplete: _onAudioRecordingComplete,
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ── Galeria unificada ───────────────────────────────
          if (totalItems == 0)
            PCPECard(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 48),
                child: Center(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: PCPEColors.primary.withValues(alpha: 0.06),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.perm_media_outlined,
                          size: 56,
                          color: PCPEColors.mediumGray,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Nenhuma mídia registrada',
                        style: TextStyle(
                          color: PCPEColors.mediumGray,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Capture fotos, grave vídeos ou áudios',
                        style: TextStyle(
                          color: PCPEColors.lightGray,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'relacionados à ocorrência',
                        style: TextStyle(
                          color: PCPEColors.lightGray,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          else
            PCPECard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const PCPESectionTitle(
                    title: 'Galeria',
                    icon: Icons.perm_media_outlined,
                  ),
                  const SizedBox(height: 12),
                  // Grid responsivo
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
                        gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          childAspectRatio: width >= 600 ? 0.8 : 0.85,
                        ),
                        itemCount: totalItems,
                        itemBuilder: (context, index) {
                          final item = widget.data.midias[index];
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
              ),
            ),

          const SizedBox(height: 24),

          // ── Resumo por tipo ─────────────────────────────────
          if (totalItems > 0) _buildResumoTipos(),
        ],
      ),
    );
  }

  Widget _buildResumoTipos() {
    final fotos = widget.data.midias
        .where((m) => m.type == MediaType.photo)
        .length;
    final videos = widget.data.midias
        .where((m) => m.type == MediaType.video)
        .length;
    final audios = widget.data.midias
        .where((m) => m.type == MediaType.audio)
        .length;

    return PCPECard(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildResumoItem(
            icon: Icons.image,
            label: 'Fotos',
            count: fotos,
            color: PCPEColors.info,
          ),
          Container(
            width: 1,
            height: 40,
            color: PCPEColors.lightGray.withValues(alpha: 0.3),
          ),
          _buildResumoItem(
            icon: Icons.videocam,
            label: 'Vídeos',
            count: videos,
            color: const Color(0xFFEF6C00),
          ),
          Container(
            width: 1,
            height: 40,
            color: PCPEColors.lightGray.withValues(alpha: 0.3),
          ),
          _buildResumoItem(
            icon: Icons.mic,
            label: 'Áudios',
            count: audios,
            color: PCPEColors.success,
          ),
        ],
      ),
    );
  }

  Widget _buildResumoItem({
    required IconData icon,
    required String label,
    required int count,
    required Color color,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 20, color: color),
        ),
        const SizedBox(height: 4),
        Text(
          '$count',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: PCPEColors.black,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: PCPEColors.mediumGray,
          ),
        ),
      ],
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