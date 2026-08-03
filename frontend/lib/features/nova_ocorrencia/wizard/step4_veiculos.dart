import 'package:flutter/material.dart';
import '../../../design_system/design_system.dart';
import '../../../shared/widgets/pcpe_input.dart';
import '../../../shared/widgets/pcpe_card.dart';
import '../../../shared/widgets/pcpe_button.dart';
import '../../../shared/widgets/pcpe_section_title.dart';
import 'ocorrencia_wizard_data.dart';

/// Etapa 4: Veículos
class Step4Veiculos extends StatefulWidget {
  final OcorrenciaWizardData data;
  final void Function() onChanged;

  const Step4Veiculos({
    super.key,
    required this.data,
    required this.onChanged,
  });

  @override
  State<Step4Veiculos> createState() => _Step4VeiculosState();
}

class _Step4VeiculosState extends State<Step4Veiculos> {
  final _situacoes = ['Apreendido', 'Abandonado', 'Recuperado', 'Incendiado', 'Danificado', 'Outros'];

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
                                child: PCPEInput(
                                  label: 'Marca',
                                  hint: 'Fabricante',
                                  prefixIcon: Icons.factory,
                                  controller: marcaCtrl,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: PCPEInput(
                                  label: 'Modelo',
                                  hint: 'Modelo',
                                  prefixIcon: Icons.directions_car,
                                  controller: modeloCtrl,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              Expanded(
                                child: PCPEInput(
                                  label: 'Ano',
                                  hint: '2024',
                                  prefixIcon: Icons.date_range,
                                  controller: anoCtrl,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: PCPEInput(
                                  label: 'Cor',
                                  hint: 'Cor do veículo',
                                  prefixIcon: Icons.palette,
                                  controller: corCtrl,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          DropdownButtonFormField<String>(
                            value: situacao,
                            decoration: InputDecoration(
                              labelText: 'Situação',
                              prefixIcon: const Icon(Icons.info_outline),
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
                            ),
                            items: _situacoes
                                .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                                .toList(),
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
                                  label: veiculo == null ? 'Adicionar' : 'Salvar',
                                  icon: Icons.save,
                                  fullWidth: true,
                                  onPressed: () {
                                    if (placaCtrl.text.trim().isEmpty) {
                                      ScaffoldMessenger.of(ctx).showSnackBar(
                                        const SnackBar(
                                          content: Text('Informe a placa do veículo.'),
                                          backgroundColor: PCPEColors.error,
                                        ),
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
                                    );
                                    if (veiculo != null && index != null) {
                                      widget.data.veiculos[index] = novo;
                                    } else {
                                      widget.data.veiculos.add(novo);
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
                        title: 'Veículos Relacionados',
                        icon: Icons.directions_car_outlined,
                      ),
                    ),
                    PCPEButton(
                      label: 'Adicionar',
                      icon: Icons.add,
                      small: true,
                      onPressed: () => _mostrarFormVeiculo(),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (widget.data.veiculos.isEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    child: const Center(
                      child: Column(
                        children: [
                          Icon(Icons.car_repair, size: 48, color: PCPEColors.lightGray),
                          SizedBox(height: 12),
                          Text(
                            'Nenhum veículo adicionado',
                            style: TextStyle(color: PCPEColors.mediumGray, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  ...List.generate(widget.data.veiculos.length, (index) {
                    final v = widget.data.veiculos[index];
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
                          backgroundColor: PCPEColors.primary.withValues(alpha: 0.1),
                          radius: 20,
                          child: const Icon(Icons.directions_car, color: PCPEColors.primary, size: 20),
                        ),
                        title: Text(
                          '${v.marca.isNotEmpty ? v.marca : '---'} ${v.modelo.isNotEmpty ? v.modelo : '---'}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: PCPEColors.black,
                          ),
                        ),
                        subtitle: Row(
                          children: [
                            Text(
                              v.placa.isNotEmpty ? v.placa : 'Sem placa',
                              style: const TextStyle(fontSize: 12, color: PCPEColors.mediumGray),
                            ),
                            if (v.ano.isNotEmpty) ...[
                              const SizedBox(width: 8),
                              Text(v.ano, style: const TextStyle(fontSize: 12, color: PCPEColors.mediumGray)),
                            ],
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: PCPEColors.warningLight,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                v.situacao,
                                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: PCPEColors.warning),
                              ),
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, size: 18, color: PCPEColors.primary),
                              onPressed: () => _mostrarFormVeiculo(veiculo: v, index: index),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline, size: 18, color: PCPEColors.error),
                              onPressed: () {
                                setState(() {
                                  widget.data.veiculos.removeAt(index);
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