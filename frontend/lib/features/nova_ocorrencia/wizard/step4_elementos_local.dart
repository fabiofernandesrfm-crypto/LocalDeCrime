import 'package:flutter/material.dart';
import '../../../design_system/design_system.dart';
import '../../../shared/widgets/pcpe_input.dart';
import '../../../shared/widgets/pcpe_card.dart';
import '../../../shared/widgets/pcpe_button.dart';
import '../../../shared/widgets/pcpe_section_title.dart';
import '../../../shared/widgets/media_capture_section.dart';
import '../../../shared/models/media_item.dart';
import 'ocorrencia_wizard_data.dart';

/// Etapa 4: Elementos Relacionados ao Local (F17).
///
/// Agrupa Veículos, Objetos e Vestígios em três blocos independentes
/// com ExpansionTile, mantendo todas as funcionalidades: adicionar,
/// editar, excluir e captura de fotografias.
class Step4ElementosLocal extends StatefulWidget {
  final OcorrenciaWizardData data;
  final void Function() onChanged;

  const Step4ElementosLocal({
    super.key,
    required this.data,
    required this.onChanged,
  });

  @override
  State<Step4ElementosLocal> createState() => _Step4ElementosLocalState();
}

class _Step4ElementosLocalState extends State<Step4ElementosLocal> {
  // ═══════════════════════════════════════════════════════════════
  // Veículos
  // ═══════════════════════════════════════════════════════════════
  final _situacoesVeiculos = [
    'Apreendido',
    'Abandonado',
    'Recuperado',
    'Incendiado',
    'Danificado',
    'Outros',
  ];

  void _mostrarFormVeiculo({VeiculoEnvolvido? veiculo, int? index}) {
    final placaCtrl = TextEditingController(text: veiculo?.placa ?? '');
    final marcaCtrl = TextEditingController(text: veiculo?.marca ?? '');
    final modeloCtrl = TextEditingController(text: veiculo?.modelo ?? '');
    final anoCtrl = TextEditingController(text: veiculo?.ano ?? '');
    final corCtrl = TextEditingController(text: veiculo?.cor ?? '');
    final obsCtrl = TextEditingController(text: veiculo?.observacoes ?? '');
    String situacao = veiculo?.situacao ?? 'Apreendido';

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
                  _buildSheetHandle(),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            veiculo == null ? 'Novo Veículo' : 'Editar Veículo',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: PCPEColors.black,
                            ),
                          ),
                          const SizedBox(height: 20),
                          PCPEInput(
                            label: 'Placa',
                            hint: 'ABC-1234',
                            prefixIcon: Icons.car_rental,
                            controller: placaCtrl,
                          ),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              Expanded(
                                child: PCPEInput(label: 'Marca', hint: 'Fabricante', prefixIcon: Icons.factory, controller: marcaCtrl),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: PCPEInput(label: 'Modelo', hint: 'Modelo', prefixIcon: Icons.directions_car, controller: modeloCtrl),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              Expanded(
                                child: PCPEInput(label: 'Ano', hint: '2024', prefixIcon: Icons.date_range, controller: anoCtrl),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: PCPEInput(label: 'Cor', hint: 'Cor do veículo', prefixIcon: Icons.palette, controller: corCtrl),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          DropdownButtonFormField<String>(
                            value: situacao,
                            decoration: _ddDecoration('Situação'),
                            items: _situacoesVeiculos.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                            onChanged: (v) => setModalState(() => situacao = v!),
                          ),
                          const SizedBox(height: 14),
                          PCPEInput(
                            label: 'Observações',
                            hint: 'Observações sobre o veículo...',
                            prefixIcon: Icons.notes,
                            maxLines: 3,
                            controller: obsCtrl,
                          ),
                          const SizedBox(height: 24),
                          _buildFormActions(
                            ctx,
                            onSave: () {
                              if (placaCtrl.text.trim().isEmpty) {
                                ScaffoldMessenger.of(ctx).showSnackBar(
                                  const SnackBar(content: Text('Informe a placa do veículo.'), backgroundColor: PCPEColors.error),
                                );
                                return;
                              }
                              final novo = VeiculoEnvolvido(
                                placa: placaCtrl.text,
                                marca: marcaCtrl.text,
                                modelo: modeloCtrl.text,
                                ano: anoCtrl.text,
                                cor: corCtrl.text,
                                situacao: situacao,
                                observacoes: obsCtrl.text,
                                midias: veiculo?.midias ?? [],
                              );
                              if (veiculo != null && index != null) {
                                widget.data.veiculos[index] = novo;
                              } else {
                                widget.data.veiculos.add(novo);
                              }
                              widget.onChanged();
                              Navigator.pop(ctx);
                            },
                            isEditing: veiculo != null,
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

  void _abrirGaleriaVeiculo(int index) {
    final veiculo = widget.data.veiculos[index];
    _abrirGaleria(
      titulo: 'Veículo: ${veiculo.placa}',
      midias: veiculo.midias,
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // Objetos
  // ═══════════════════════════════════════════════════════════════
  final _categoriasObjetos = [
    'Arma de Fogo', 'Arma Branca', 'Documento', 'Dispositivo Eletrônico',
    'Substância', 'Vestuário', 'Joia/Valor', 'Ferramenta', 'Outros',
  ];
  final _situacoesObjetos = ['Coletado', 'Apreendido', 'Periciado', 'Devolvido', 'Destruído'];

  void _mostrarFormObjeto({ObjetoRelacionado? objeto, int? index}) {
    final descCtrl = TextEditingController(text: objeto?.descricao ?? '');
    final qtdCtrl = TextEditingController(text: objeto != null ? objeto.quantidade.toString() : '1');
    final obsCtrl = TextEditingController(text: objeto?.observacoes ?? '');
    String categoria = objeto?.categoria ?? _categoriasObjetos.first;
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
                  _buildSheetHandle(),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            objeto == null ? 'Novo Objeto' : 'Editar Objeto',
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: PCPEColors.black),
                          ),
                          const SizedBox(height: 20),
                          DropdownButtonFormField<String>(
                            value: categoria,
                            decoration: _ddDecoration('Categoria'),
                            items: _categoriasObjetos.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                            onChanged: (v) => setModalState(() => categoria = v!),
                          ),
                          const SizedBox(height: 14),
                          PCPEInput(label: 'Descrição', hint: 'Descreva o objeto...', prefixIcon: Icons.description, controller: descCtrl),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              Expanded(
                                child: PCPEInput(label: 'Quantidade', hint: '1', prefixIcon: Icons.numbers, keyboardType: TextInputType.number, controller: qtdCtrl),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: DropdownButtonFormField<String>(
                                  value: situacao,
                                  decoration: _ddDecoration('Situação'),
                                  items: _situacoesObjetos.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                                  onChanged: (v) => setModalState(() => situacao = v!),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          PCPEInput(label: 'Observações', hint: 'Observações adicionais...', prefixIcon: Icons.notes, maxLines: 3, controller: obsCtrl),
                          const SizedBox(height: 24),
                          _buildFormActions(
                            ctx,
                            onSave: () {
                              if (descCtrl.text.trim().isEmpty) {
                                ScaffoldMessenger.of(ctx).showSnackBar(
                                  const SnackBar(content: Text('Informe a descrição do objeto.'), backgroundColor: PCPEColors.error),
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
                            isEditing: objeto != null,
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
    _abrirGaleria(
      titulo: 'Objeto: ${objeto.descricao}',
      midias: objeto.midias,
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // Vestígios
  // ═══════════════════════════════════════════════════════════════
  final _tiposVestigios = [
    'Digital', 'Biológico', 'Balístico', 'Químico',
    'Documental', 'Material', 'Informático', 'Outros',
  ];

  void _mostrarFormVestigio({VestigioEncontrado? vestigio, int? index}) {
    final descCtrl = TextEditingController(text: vestigio?.descricao ?? '');
    final localCtrl = TextEditingController(text: vestigio?.localizacao ?? '');
    final respCtrl = TextEditingController(text: vestigio?.responsavel ?? '');
    final obsCtrl = TextEditingController(text: vestigio?.observacoes ?? '');
    String tipo = vestigio?.tipo ?? _tiposVestigios.first;
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
                  _buildSheetHandle(),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            vestigio == null ? 'Novo Vestígio' : 'Editar Vestígio',
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: PCPEColors.black),
                          ),
                          const SizedBox(height: 20),
                          DropdownButtonFormField<String>(
                            value: tipo,
                            decoration: _ddDecoration('Tipo do Vestígio'),
                            items: _tiposVestigios.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                            onChanged: (v) => setModalState(() => tipo = v!),
                          ),
                          const SizedBox(height: 14),
                          PCPEInput(label: 'Descrição', hint: 'Descreva o vestígio encontrado...', prefixIcon: Icons.description, maxLines: 2, controller: descCtrl),
                          const SizedBox(height: 14),
                          PCPEInput(label: 'Localização', hint: 'Local específico onde foi encontrado', prefixIcon: Icons.location_searching, controller: localCtrl),
                          const SizedBox(height: 14),
                          PCPEInput(label: 'Responsável pela Coleta', hint: 'Nome do perito/responsável', prefixIcon: Icons.person, controller: respCtrl),
                          const SizedBox(height: 14),
                          SwitchListTile(
                            value: coletado,
                            onChanged: (v) => setModalState(() => coletado = v),
                            title: const Text('Coletado', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: PCPEColors.black)),
                            subtitle: const Text('Indica se o vestígio já foi coletado pela perícia', style: TextStyle(fontSize: 12, color: PCPEColors.mediumGray)),
                            activeThumbColor: PCPEColors.primary,
                            contentPadding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          const SizedBox(height: 14),
                          PCPEInput(label: 'Observações', hint: 'Observações adicionais...', prefixIcon: Icons.notes, maxLines: 3, controller: obsCtrl),
                          const SizedBox(height: 24),
                          _buildFormActions(
                            ctx,
                            onSave: () {
                              if (descCtrl.text.trim().isEmpty) {
                                ScaffoldMessenger.of(ctx).showSnackBar(
                                  const SnackBar(content: Text('Informe a descrição do vestígio.'), backgroundColor: PCPEColors.error),
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
                            isEditing: vestigio != null,
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
    _abrirGaleria(
      titulo: 'Vestígio: ${vestigio.descricao}',
      midias: vestigio.midias,
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // Galeria compartilhada
  // ═══════════════════════════════════════════════════════════════

  void _abrirGaleria({required String titulo, required List<MediaItem> midias}) {
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
                  _buildSheetHandle(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(titulo, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: PCPEColors.black)),
                        ),
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
                        midias: midias,
                        onChanged: () {
                          setSheetState(() {});
                          setState(() {});
                          widget.onChanged();
                        },
                        title: 'Fotografias',
                        subtitle: 'Fotos vinculadas a este item',
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

  // ═══════════════════════════════════════════════════════════════
  // Widgets auxiliares
  // ═══════════════════════════════════════════════════════════════

  Widget _buildSheetHandle() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: PCPEColors.lightGray,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildFormActions(BuildContext ctx, {required VoidCallback onSave, required bool isEditing}) {
    return Row(
      children: [
        Expanded(
          child: PCPEButton(label: 'Cancelar', outlined: true, fullWidth: true, onPressed: () => Navigator.pop(ctx)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: PCPEButton(label: isEditing ? 'Salvar' : 'Adicionar', icon: Icons.save, fullWidth: true, onPressed: onSave),
        ),
      ],
    );
  }

  InputDecoration _ddDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: PCPEColors.cardGray,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: PCPEColors.lightGray.withValues(alpha: 0.5))),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: PCPEColors.lightGray.withValues(alpha: 0.5))),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: PCPEColors.primary, width: 2)),
      labelStyle: const TextStyle(color: PCPEColors.darkGray, fontSize: 14),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  Widget _buildItemCard(String titulo, String subtitulo, {Widget? trailing}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: PCPEColors.cardGray,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(titulo, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: PCPEColors.black)),
                if (subtitulo.isNotEmpty)
                  Text(subtitulo, style: const TextStyle(fontSize: 11, color: PCPEColors.mediumGray)),
              ],
            ),
          ),
          if (trailing != null) trailing,
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // BUILD
  // ═══════════════════════════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ══════════════════════════════════════════════════════
          // Bloco 1: Veículos Relacionados
          // ══════════════════════════════════════════════════════
          PCPECard(
            child: ExpansionTile(
              initiallyExpanded: widget.data.veiculos.isNotEmpty,
              tilePadding: EdgeInsets.zero,
              childrenPadding: const EdgeInsets.fromLTRB(0, 0, 0, 12),
              shape: const Border(),
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: PCPEColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.directions_car, size: 18, color: PCPEColors.primary),
              ),
              title: const Text(
                'Veículos Relacionados',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: PCPEColors.black),
              ),
              subtitle: Text(
                '${widget.data.veiculos.length} veículo(s) cadastrado(s)',
                style: const TextStyle(fontSize: 12, color: PCPEColors.mediumGray),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ...widget.data.veiculos.asMap().entries.map((entry) {
                        final idx = entry.key;
                        final v = entry.value;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: _buildItemCard(
                            '${v.marca} ${v.modelo}',
                            'Placa: ${v.placa.isNotEmpty ? v.placa : '—'}  •  ${v.situacao}',
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.photo_camera, size: 18, color: PCPEColors.primary.withValues(alpha: 0.8)),
                                  onPressed: () => _abrirGaleriaVeiculo(idx),
                                  tooltip: 'Fotos do veículo',
                                ),
                                IconButton(
                                  icon: const Icon(Icons.edit, size: 18, color: PCPEColors.mediumGray),
                                  onPressed: () => _mostrarFormVeiculo(veiculo: v, index: idx),
                                  tooltip: 'Editar',
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, size: 18, color: PCPEColors.error),
                                  onPressed: () => _confirmarExclusao('veículo', () {
                                    widget.data.veiculos.removeAt(idx);
                                    widget.onChanged();
                                  }),
                                  tooltip: 'Excluir',
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                      const SizedBox(height: 8),
                      PCPEButton(
                        label: 'Adicionar Veículo',
                        icon: Icons.add,
                        fullWidth: true,
                        onPressed: () => _mostrarFormVeiculo(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // ══════════════════════════════════════════════════════
          // Bloco 2: Objetos Relacionados
          // ══════════════════════════════════════════════════════
          PCPECard(
            child: ExpansionTile(
              initiallyExpanded: widget.data.objetos.isNotEmpty,
              tilePadding: EdgeInsets.zero,
              childrenPadding: const EdgeInsets.fromLTRB(0, 0, 0, 12),
              shape: const Border(),
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: PCPEColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.inventory_2, size: 18, color: PCPEColors.primary),
              ),
              title: const Text(
                'Objetos Relacionados',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: PCPEColors.black),
              ),
              subtitle: Text(
                '${widget.data.objetos.length} objeto(s) cadastrado(s)',
                style: const TextStyle(fontSize: 12, color: PCPEColors.mediumGray),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ...widget.data.objetos.asMap().entries.map((entry) {
                        final idx = entry.key;
                        final o = entry.value;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: _buildItemCard(
                            o.descricao.isNotEmpty ? o.descricao : '(sem descrição)',
                            '${o.categoria}  •  Quantidade: ${o.quantidade}  •  ${o.situacao}',
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.photo_camera, size: 18, color: PCPEColors.primary.withValues(alpha: 0.8)),
                                  onPressed: () => _abrirGaleriaObjeto(idx),
                                  tooltip: 'Fotos do objeto',
                                ),
                                IconButton(
                                  icon: const Icon(Icons.edit, size: 18, color: PCPEColors.mediumGray),
                                  onPressed: () => _mostrarFormObjeto(objeto: o, index: idx),
                                  tooltip: 'Editar',
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, size: 18, color: PCPEColors.error),
                                  onPressed: () => _confirmarExclusao('objeto', () {
                                    widget.data.objetos.removeAt(idx);
                                    widget.onChanged();
                                  }),
                                  tooltip: 'Excluir',
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                      const SizedBox(height: 8),
                      PCPEButton(
                        label: 'Adicionar Objeto',
                        icon: Icons.add,
                        fullWidth: true,
                        onPressed: () => _mostrarFormObjeto(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // ══════════════════════════════════════════════════════
          // Bloco 3: Vestígios Encontrados
          // ══════════════════════════════════════════════════════
          PCPECard(
            child: ExpansionTile(
              initiallyExpanded: widget.data.vestigios.isNotEmpty,
              tilePadding: EdgeInsets.zero,
              childrenPadding: const EdgeInsets.fromLTRB(0, 0, 0, 12),
              shape: const Border(),
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: PCPEColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.biotech, size: 18, color: PCPEColors.primary),
              ),
              title: const Text(
                'Vestígios Encontrados',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: PCPEColors.black),
              ),
              subtitle: Text(
                '${widget.data.vestigios.length} vestígio(s) cadastrado(s)',
                style: const TextStyle(fontSize: 12, color: PCPEColors.mediumGray),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ...widget.data.vestigios.asMap().entries.map((entry) {
                        final idx = entry.key;
                        final v = entry.value;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: _buildItemCard(
                            v.descricao.isNotEmpty ? v.descricao : '(sem descrição)',
                            '${v.tipo}  •  ${v.coletado ? "Coletado" : "Pendente"}  •  ${v.localizacao.isNotEmpty ? v.localizacao : "Local não informado"}',
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.photo_camera, size: 18, color: PCPEColors.primary.withValues(alpha: 0.8)),
                                  onPressed: () => _abrirGaleriaVestigio(idx),
                                  tooltip: 'Fotos do vestígio',
                                ),
                                IconButton(
                                  icon: const Icon(Icons.edit, size: 18, color: PCPEColors.mediumGray),
                                  onPressed: () => _mostrarFormVestigio(vestigio: v, index: idx),
                                  tooltip: 'Editar',
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, size: 18, color: PCPEColors.error),
                                  onPressed: () => _confirmarExclusao('vestígio', () {
                                    widget.data.vestigios.removeAt(idx);
                                    widget.onChanged();
                                  }),
                                  tooltip: 'Excluir',
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                      const SizedBox(height: 8),
                      PCPEButton(
                        label: 'Adicionar Vestígio',
                        icon: Icons.add,
                        fullWidth: true,
                        onPressed: () => _mostrarFormVestigio(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  void _confirmarExclusao(String tipo, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: PCPEColors.pureWhite,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        title: Text('Excluir $tipo', style: const TextStyle(fontWeight: FontWeight.w700, color: PCPEColors.black)),
        content: Text('Tem certeza que deseja excluir este $tipo? Esta ação não pode ser desfeita.', style: const TextStyle(fontSize: 13, color: PCPEColors.darkGray)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar', style: TextStyle(color: PCPEColors.darkGray))),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              onConfirm();
            },
            style: ElevatedButton.styleFrom(backgroundColor: PCPEColors.error, foregroundColor: PCPEColors.pureWhite, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }
}