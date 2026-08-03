import 'package:flutter/material.dart';
import '../../../design_system/design_system.dart';
import '../../../shared/widgets/pcpe_card.dart';
import '../../../shared/widgets/pcpe_button.dart';
import '../../../shared/widgets/pcpe_section_title.dart';
import 'ocorrencia_wizard_data.dart';

/// Etapa 7: Fotografias
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
  int _fotoId = 0;
  final _categorias = ['Geral', 'Local do Crime', 'Vestígio', 'Veículo', 'Objeto', 'Perícia'];

  void _adicionarFotografia() {
    final now = DateTime.now();
    final foto = FotografiaRegistro(
      id: _fotoId++,
      categoria: 'Geral',
      legenda: 'Fotografia ${widget.data.fotografias.length + 1}',
      data: now,
      hora:
          '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}',
      gps: widget.data.gpsCapturado
          ? '${widget.data.latitude}, ${widget.data.longitude}'
          : 'GPS não disponível',
    );

    setState(() {
      widget.data.fotografias.add(foto);
      widget.onChanged();
    });
  }

  void _editarFotografia(int index) {
    final foto = widget.data.fotografias[index];
    final legendaCtrl = TextEditingController(text: foto.legenda);
    String categoria = foto.categoria;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
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
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: PCPEColors.lightGray,
                      borderRadius: BorderRadius.circular(2),
                    ),
                    alignment: Alignment.center,
                  ),
                  const Text(
                    'Editar Fotografia',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: PCPEColors.black),
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    initialValue: categoria,
                    decoration: InputDecoration(
                      labelText: 'Categoria',
                      filled: true,
                      fillColor: PCPEColors.cardGray,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: PCPEColors.lightGray.withValues(alpha: 0.5)),
                      ),
                    ),
                    items: _categorias
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (v) => setModalState(() => categoria = v!),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: legendaCtrl,
                    decoration: InputDecoration(
                      labelText: 'Legenda',
                      filled: true,
                      fillColor: PCPEColors.cardGray,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: PCPEColors.lightGray.withValues(alpha: 0.5)),
                      ),
                    ),
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
                              widget.data.fotografias[index].categoria = categoria;
                              widget.data.fotografias[index].legenda = legendaCtrl.text;
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
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PCPECard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: PCPESectionTitle(
                        title: 'Galeria de Fotografias',
                        icon: Icons.photo_camera_outlined,
                      ),
                    ),
                    PCPEButton(
                      label: 'Adicionar',
                      icon: Icons.add_a_photo,
                      small: true,
                      onPressed: _adicionarFotografia,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (widget.data.fotografias.isEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: Center(
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: PCPEColors.primary.withValues(alpha: 0.08),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.photo_library_outlined,
                              size: 48,
                              color: PCPEColors.mediumGray,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Nenhuma fotografia registrada',
                            style: TextStyle(
                              color: PCPEColors.mediumGray,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Adicione fotografias do local e vestígios',
                            style: TextStyle(
                              color: PCPEColors.lightGray,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 0.85,
                    ),
                    itemCount: widget.data.fotografias.length,
                    itemBuilder: (context, index) {
                      final foto = widget.data.fotografias[index];
                      return GestureDetector(
                        onTap: () => _editarFotografia(index),
                        child: Container(
                          decoration: BoxDecoration(
                            color: foto.placeholderColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: foto.placeholderColor.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: foto.placeholderColor.withValues(alpha: 0.15),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  foto.placeholderIcon,
                                  size: 28,
                                  color: foto.placeholderColor,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 6),
                                child: Text(
                                  foto.legenda,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: PCPEColors.black,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 6),
                                child: Text(
                                  foto.categoria,
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: foto.placeholderColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${foto.data.day.toString().padLeft(2, '0')}/${foto.data.month.toString().padLeft(2, '0')}/${foto.data.year} ${foto.hora}',
                                style: const TextStyle(
                                  fontSize: 9,
                                  color: PCPEColors.mediumGray,
                                ),
                              ),
                              const Spacer(),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    widget.data.fotografias.removeAt(index);
                                    widget.onChanged();
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 4),
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
                    },
                  ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}