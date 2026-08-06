import 'package:flutter/material.dart';
import '../../../design_system/design_system.dart';
import '../../../shared/widgets/pcpe_input.dart';
import '../../../shared/widgets/pcpe_card.dart';
import '../../../shared/widgets/pcpe_button.dart';
import '../../../shared/widgets/media_capture_section.dart';
import 'ocorrencia_wizard_data.dart';

/// Etapa 5: Objetos
/// Cada objeto possui sua própria galeria de fotografias.
class Step5Objetos extends StatefulWidget {
  final OcorrenciaWizardData data;
  final void Function() onChanged;

  const Step5Objetos({
    super.key,
    required this.data,
    required this.onChanged,
  });

  @override
  State<Step5Objetos> createState() => _Step5ObjetosState();
}

class _Step5ObjetosState extends State<Step5Objetos> {
  final _categorias = [
    'Arma de Fogo',
    'Arma Branca',
    'Documento',
    'Dispositivo Eletrônico',
    'Substância',
    'Vestuário',
    'Joia/Valor',
    'Ferramenta',
    'Outros',
  ];

  final _situacoes = ['Coletado', 'Apreendido', 'Periciado', 'Devolvido', 'Destruído'];

  void _mostrarFormObjeto({ObjetoRelacionado? objeto, int? index}) {
    final descCtrl = TextEditingController(text: objeto?.descricao ?? '');
    final qtdCtrl =
        TextEditingController(text: objeto != null ? objeto.quantidade.toString() : '1');
    final obsCtrl = TextEditingController(text: objeto?.observacoes ?? '');
    String categoria = objeto?.categoria ?? _categorias.first;
    String situacao = objeto?.situacao ?? 'Coletado';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.75,
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
                            objeto == null ? 'Novo Objeto' : 'Editar Objeto',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: PCPEColors.black,
                            ),
                          ),
                          const SizedBox(height: 20),
                          DropdownButtonFormField<String>(
                            value: categoria,
                            decoration: _dropdownDecoration('Categoria'),
                            items: _categorias
                                .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                                .toList(),
                            onChanged: (v) => setModalState(() => categoria = v!),
                          ),
                          const SizedBox(height: 14),
                          PCPEInput(
                            label: 'Descrição',
                            hint: 'Descreva o objeto...',
                            prefixIcon: Icons.description,
                            controller: descCtrl,
                          ),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              Expanded(
                                child: PCPEInput(
                                  label: 'Quantidade',
                                  hint: '1',
                                  prefixIcon: Icons.numbers,
                                  keyboardType: TextInputType.number,
                                  controller: qtdCtrl,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: DropdownButtonFormField<String>(
                                  value: situacao,
                                  decoration: _dropdownDecoration('Situação'),
                                  items: _situacoes
                                      .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                                      .toList(),
                                  onChanged: (v) => setModalState(() => situacao = v!),
                                ),
                              ),
                            ],
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
                                  label: objeto == null ? 'Adicionar' : 'Salvar',
                                  icon: Icons.save,
                                  fullWidth: true,
                                  onPressed: () {
                                    if (descCtrl.text.trim().isEmpty) {
                                      ScaffoldMessenger.of(ctx).showSnackBar(
                                        const SnackBar(
                                          content: Text('Informe a descrição do objeto.'),
                                          backgroundColor: PCPEColors.error,
                                        ),
                                      );
                                      return;
                                    }
                                    final novo = ObjetoRelacionado(
                                      categoria: categoria,
                                      descricao: descCtrl.text,
                                      quantidade: int.tryParse(qtdCtrl.text) ?? 1,
                                      situacao: situacao,
                                      observacoes: obsCtrl.text,
                                      midias: objeto?.midias ?? [],
                                    );
                                    if (objeto != null && index != null) {
                                      widget.data.objetos[index] = novo;
                                    } else {
                                      widget.data.objetos.add(novo);
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

  void _abrirGaleriaObjeto(int index) {
    final objeto = widget.data.objetos[index];
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
                          'Objeto: ${objeto.descricao}',
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
                        midias: objeto.midias,
                        onChanged: () {
                          setSheetState(() {});
                          setState(() {});
                          widget.onChanged();
                        },
                        title: 'Fotografias do Objeto',
                        subtitle: 'Fotos vinculadas a este objeto',
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

  InputDecoration _dropdownDecoration(String label) {
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
                      child: const Icon(Icons.inventory_2_outlined, size: 20, color: PCPEColors.primary),
                    );
                    final titleWidget = const Expanded(
                      child: Text(
                        'Objetos Relacionados',
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
                      onPressed: () => _mostrarFormObjeto(),
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
                if (widget.data.objetos.isEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    child: const Center(
                      child: Column(
                        children: [
                          Icon(Icons.inventory, size: 48, color: PCPEColors.lightGray),
                          SizedBox(height: 12),
                          Text(
                            'Nenhum objeto adicionado',
                            style: TextStyle(color: PCPEColors.mediumGray, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  ...List.generate(widget.data.objetos.length, (index) {
                    final o = widget.data.objetos[index];
                    final fotoCount = o.midias.length;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: PCPEColors.cardGray,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: PCPEColors.lightGray.withValues(alpha: 0.3)),
                      ),
                      child: ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        leading: CircleAvatar(
                          backgroundColor: PCPEColors.primary.withValues(alpha: 0.1),
                          radius: 20,
                          child:
                              const Icon(Icons.inventory_2, color: PCPEColors.primary, size: 20),
                        ),
                        title: Text(
                          o.descricao,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: PCPEColors.black,
                          ),
                        ),
                        subtitle: Row(
                          children: [
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: PCPEColors.infoLight,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                o.categoria,
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: PCPEColors.info,
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
                            const SizedBox(width: 8),
                            Text(
                              'Qtd: ${o.quantidade}',
                              style: const TextStyle(
                                  fontSize: 12, color: PCPEColors.mediumGray),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              o.situacao,
                              style: const TextStyle(
                                  fontSize: 11, color: PCPEColors.success),
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.photo_camera, size: 18, color: PCPEColors.info),
                              tooltip: 'Fotografias',
                              onPressed: () => _abrirGaleriaObjeto(index),
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit, size: 18,
                                  color: PCPEColors.primary),
                              onPressed: () =>
                                  _mostrarFormObjeto(objeto: o, index: index),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline, size: 18,
                                  color: PCPEColors.error),
                              onPressed: () {
                                setState(() {
                                  widget.data.objetos.removeAt(index);
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