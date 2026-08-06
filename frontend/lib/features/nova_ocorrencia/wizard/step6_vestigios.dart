import 'package:flutter/material.dart';
import '../../../design_system/design_system.dart';
import '../../../shared/widgets/pcpe_input.dart';
import '../../../shared/widgets/pcpe_card.dart';
import '../../../shared/widgets/pcpe_button.dart';
import '../../../shared/widgets/media_capture_section.dart';
import 'ocorrencia_wizard_data.dart';

/// Etapa 6: Vestígios
/// Cada vestígio possui sua própria galeria de fotografias.
class Step6Vestigios extends StatefulWidget {
  final OcorrenciaWizardData data;
  final void Function() onChanged;

  const Step6Vestigios({
    super.key,
    required this.data,
    required this.onChanged,
  });

  @override
  State<Step6Vestigios> createState() => _Step6VestigiosState();
}

class _Step6VestigiosState extends State<Step6Vestigios> {
  final _tipos = [
    'Digital',
    'Biológico',
    'Balístico',
    'Químico',
    'Documental',
    'Material',
    'Informático',
    'Outros',
  ];

  void _mostrarFormVestigio({VestigioEncontrado? vestigio, int? index}) {
    final descCtrl = TextEditingController(text: vestigio?.descricao ?? '');
    final localCtrl = TextEditingController(text: vestigio?.localizacao ?? '');
    final respCtrl = TextEditingController(text: vestigio?.responsavel ?? '');
    final obsCtrl = TextEditingController(text: vestigio?.observacoes ?? '');
    String tipo = vestigio?.tipo ?? _tipos.first;
    bool coletado = vestigio?.coletado ?? false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.8,
              decoration: const BoxDecoration(
                color: PCPEColors.pureWhite,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: PCPEColors.lightGray,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            vestigio == null ? 'Novo Vestígio' : 'Editar Vestígio',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: PCPEColors.black,
                            ),
                          ),
                          const SizedBox(height: 20),
                          DropdownButtonFormField<String>(
                            value: tipo,
                            decoration: _decoration('Tipo do Vestígio'),
                            items: _tipos
                                .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                                .toList(),
                            onChanged: (v) => setModalState(() => tipo = v!),
                          ),
                          const SizedBox(height: 14),
                          PCPEInput(
                            label: 'Descrição',
                            hint: 'Descreva o vestígio encontrado...',
                            prefixIcon: Icons.description,
                            maxLines: 2,
                            controller: descCtrl,
                          ),
                          const SizedBox(height: 14),
                          PCPEInput(
                            label: 'Localização',
                            hint: 'Local específico onde foi encontrado',
                            prefixIcon: Icons.location_searching,
                            controller: localCtrl,
                          ),
                          const SizedBox(height: 14),
                          PCPEInput(
                            label: 'Responsável pela Coleta',
                            hint: 'Nome do perito/responsável',
                            prefixIcon: Icons.person,
                            controller: respCtrl,
                          ),
                          const SizedBox(height: 14),
                          SwitchListTile(
                            value: coletado,
                            onChanged: (v) => setModalState(() => coletado = v),
                            title: const Text(
                              'Coletado',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: PCPEColors.black,
                              ),
                            ),
                            subtitle: const Text(
                              'Indica se o vestígio já foi coletado pela perícia',
                              style: TextStyle(fontSize: 12, color: PCPEColors.mediumGray),
                            ),
                            activeThumbColor: PCPEColors.primary,
                            contentPadding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          const SizedBox(height: 14),
                          PCPEInput(
                            label: 'Observações',
                            hint: 'Observações adicionais...',
                            prefixIcon: Icons.notes,
                            maxLines: 3,
                            controller: obsCtrl,
                          ),
                          const SizedBox(height: 24),
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
                                  label: vestigio == null ? 'Adicionar' : 'Salvar',
                                  icon: Icons.save,
                                  fullWidth: true,
                                  onPressed: () {
                                    if (descCtrl.text.trim().isEmpty) {
                                      ScaffoldMessenger.of(ctx).showSnackBar(
                                        const SnackBar(
                                          content: Text('Informe a descrição do vestígio.'),
                                          backgroundColor: PCPEColors.error,
                                        ),
                                      );
                                      return;
                                    }
                                    final novo = VestigioEncontrado(
                                      tipo: tipo,
                                      descricao: descCtrl.text,
                                      localizacao: localCtrl.text,
                                      coletado: coletado,
                                      responsavel: respCtrl.text,
                                      observacoes: obsCtrl.text,
                                      midias: vestigio?.midias ?? [],
                                    );
                                    if (vestigio != null && index != null) {
                                      widget.data.vestigios[index] = novo;
                                    } else {
                                      widget.data.vestigios.add(novo);
                                    }
                                    widget.onChanged();
                                    Navigator.pop(ctx);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _abrirGaleriaVestigio(int index) {
    final vestigio = widget.data.vestigios[index];
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.9,
              decoration: const BoxDecoration(
                color: PCPEColors.background,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: PCPEColors.lightGray,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Text(
                          'Vestígio: ${vestigio.descricao}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: PCPEColors.black,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(ctx),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: MediaCaptureSection(
                        midias: vestigio.midias,
                        onChanged: () {
                          setSheetState(() {});
                          setState(() {});
                          widget.onChanged();
                        },
                        title: 'Fotografias do Vestígio',
                        subtitle: 'Fotos vinculadas a este vestígio',
                        gpsTexto: 'GPS não disponível',
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  InputDecoration _decoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: PCPEColors.cardGray,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: PCPEColors.lightGray.withValues(alpha: 0.5)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: PCPEColors.lightGray.withValues(alpha: 0.5)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: PCPEColors.primary, width: 2),
      ),
      labelStyle: const TextStyle(color: PCPEColors.darkGray, fontSize: 14),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isNarrow = constraints.maxWidth < 400;
                    final iconWidget = Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: PCPEColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.biotech_outlined, size: 20, color: PCPEColors.primary),
                    );
                    final titleWidget = const Expanded(
                      child: Text(
                        'Vestígios Encontrados',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: PCPEColors.black,
                          letterSpacing: -0.3,
                        ),
                      ),
                    );
                    final buttonWidget = PCPEButton(
                      label: 'Adicionar',
                      icon: Icons.add,
                      small: true,
                      onPressed: () => _mostrarFormVestigio(),
                    );

                    if (isNarrow) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              iconWidget,
                              const SizedBox(width: 14),
                              titleWidget,
                            ],
                          ),
                          const SizedBox(height: 8),
                          Align(
                            alignment: Alignment.centerRight,
                            child: buttonWidget,
                          ),
                        ],
                      );
                    }
                    return Row(
                      children: [
                        iconWidget,
                        const SizedBox(width: 14),
                        titleWidget,
                        buttonWidget,
                      ],
                    );
                  },
                ),
                const SizedBox(height: 12),
                if (widget.data.vestigios.isEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    child: const Center(
                      child: Column(
                        children: [
                          Icon(Icons.search_off, size: 48, color: PCPEColors.lightGray),
                          SizedBox(height: 12),
                          Text(
                            'Nenhum vestígio cadastrado',
                            style: TextStyle(color: PCPEColors.mediumGray, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  ...List.generate(widget.data.vestigios.length, (index) {
                    final v = widget.data.vestigios[index];
                    final fotoCount = v.midias.length;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: PCPEColors.cardGray,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: PCPEColors.lightGray.withValues(alpha: 0.3)),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        leading: CircleAvatar(
                          backgroundColor: v.coletado
                              ? PCPEColors.successLight
                              : PCPEColors.warningLight,
                          radius: 20,
                          child: Icon(
                            v.coletado ? Icons.check_circle : Icons.pending,
                            color: v.coletado ? PCPEColors.success : PCPEColors.warning,
                            size: 20,
                          ),
                        ),
                        title: Text(
                          v.descricao,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: PCPEColors.black,
                          ),
                        ),
                        subtitle: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: PCPEColors.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                v.tipo,
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: PCPEColors.primary,
                                ),
                              ),
                            ),
                            if (fotoCount > 0) ...[
                              const SizedBox(width: 8),
                              Icon(Icons.photo_camera, size: 14, color: PCPEColors.primary.withValues(alpha: 0.7)),
                              const SizedBox(width: 2),
                              Text(
                                '$fotoCount',
                                style: TextStyle(fontSize: 12, color: PCPEColors.primary.withValues(alpha: 0.7), fontWeight: FontWeight.w600),
                              ),
                            ],
                            if (v.localizacao.isNotEmpty) ...[
                              const SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  v.localizacao,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: PCPEColors.mediumGray,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.photo_camera, size: 18, color: PCPEColors.info),
                              tooltip: 'Fotografias',
                              onPressed: () => _abrirGaleriaVestigio(index),
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit, size: 18, color: PCPEColors.primary),
                              onPressed: () => _mostrarFormVestigio(vestigio: v, index: index),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline, size: 18, color: PCPEColors.error),
                              onPressed: () {
                                setState(() {
                                  widget.data.vestigios.removeAt(index);
                                  widget.onChanged();
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}