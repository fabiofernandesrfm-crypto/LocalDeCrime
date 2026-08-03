import 'package:flutter/material.dart';
import '../../../design_system/design_system.dart';
import '../../../shared/widgets/pcpe_input.dart';
import '../../../shared/widgets/pcpe_card.dart';
import '../../../shared/widgets/pcpe_button.dart';
import '../../../shared/widgets/pcpe_section_title.dart';
import 'ocorrencia_wizard_data.dart';

/// Etapa 3: Pessoas Envolvidas
class Step3Pessoas extends StatefulWidget {
  final OcorrenciaWizardData data;
  final void Function() onChanged;

  const Step3Pessoas({
    super.key,
    required this.data,
    required this.onChanged,
  });

  @override
  State<Step3Pessoas> createState() => _Step3PessoasState();
}

class _Step3PessoasState extends State<Step3Pessoas> {
  final _tiposPessoa = ['Vítima', 'Suspeito', 'Testemunha', 'Comunicante'];

  void _mostrarFormPessoa({PessoaEnvolvida? pessoa, int? index}) {
    final nomeCtrl = TextEditingController(text: pessoa?.nome ?? '');
    final cpfCtrl = TextEditingController(text: pessoa?.cpf ?? '');
    final telefoneCtrl = TextEditingController(text: pessoa?.telefone ?? '');
    final enderecoCtrl = TextEditingController(text: pessoa?.endereco ?? '');
    final obsCtrl = TextEditingController(text: pessoa?.observacoes ?? '');
    String tipo = pessoa?.tipo ?? 'Vítima';
    DateTime? dataNasc = pessoa?.dataNascimento;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.85,
              decoration: const BoxDecoration(
                color: PCPEColors.pureWhite,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                children: [
                  // Handle
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
                            pessoa == null ? 'Nova Pessoa' : 'Editar Pessoa',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: PCPEColors.black,
                            ),
                          ),
                          const SizedBox(height: 20),
                          DropdownButtonFormField<String>(
                            value: tipo,
                            decoration: InputDecoration(
                              labelText: 'Tipo de Envolvimento',
                              prefixIcon: const Icon(Icons.person_outline),
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
                            items: _tiposPessoa.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                            onChanged: (v) => setModalState(() => tipo = v!),
                          ),
                          const SizedBox(height: 14),
                          PCPEInput(
                            label: 'Nome Completo',
                            hint: 'Nome da pessoa',
                            prefixIcon: Icons.badge,
                            controller: nomeCtrl,
                          ),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              Expanded(
                                child: PCPEInput(
                                  label: 'CPF',
                                  hint: '000.000.000-00',
                                  prefixIcon: Icons.credit_card,
                                  controller: cpfCtrl,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: InkWell(
                                  onTap: () async {
                                    final picked = await showDatePicker(
                                      context: ctx,
                                      initialDate: dataNasc ?? DateTime(1990),
                                      firstDate: DateTime(1900),
                                      lastDate: DateTime.now(),
                                      builder: (ctx, child) => Theme(
                                        data: Theme.of(ctx).copyWith(
                                          colorScheme: const ColorScheme.light(
                                            primary: PCPEColors.primary,
                                            onPrimary: PCPEColors.pureWhite,
                                            surface: PCPEColors.pureWhite,
                                          ),
                                        ),
                                        child: child!,
                                      ),
                                    );
                                    if (picked != null) {
                                      setModalState(() => dataNasc = picked);
                                    }
                                  },
                                  borderRadius: BorderRadius.circular(10),
                                  child: PCPEInput(
                                    label: 'Data Nasc.',
                                    hint: 'DD/MM/AAAA',
                                    prefixIcon: Icons.cake,
                                    readOnly: true,
                                    controller: TextEditingController(
                                      text: dataNasc != null
                                          ? '${dataNasc!.day.toString().padLeft(2, '0')}/${dataNasc!.month.toString().padLeft(2, '0')}/${dataNasc!.year}'
                                          : '',
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          PCPEInput(
                            label: 'Telefone',
                            hint: '(81) 99999-9999',
                            prefixIcon: Icons.phone,
                            controller: telefoneCtrl,
                          ),
                          const SizedBox(height: 14),
                          PCPEInput(
                            label: 'Endereço',
                            hint: 'Endereço completo',
                            prefixIcon: Icons.home,
                            controller: enderecoCtrl,
                          ),
                          const SizedBox(height: 14),
                          PCPEInput(
                            label: 'Observações',
                            hint: 'Informações relevantes...',
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
                                  label: pessoa == null ? 'Adicionar' : 'Salvar',
                                  icon: Icons.save,
                                  fullWidth: true,
                                  onPressed: () {
                                    if (nomeCtrl.text.trim().isEmpty) {
                                      ScaffoldMessenger.of(ctx).showSnackBar(
                                        const SnackBar(
                                          content: Text('Informe o nome da pessoa.'),
                                          backgroundColor: PCPEColors.error,
                                        ),
                                      );
                                      return;
                                    }
                                    final nova = PessoaEnvolvida(
                                      nome: nomeCtrl.text,
                                      cpf: cpfCtrl.text,
                                      dataNascimento: dataNasc,
                                      telefone: telefoneCtrl.text,
                                      endereco: enderecoCtrl.text,
                                      tipo: tipo,
                                      observacoes: obsCtrl.text,
                                    );
                                    if (pessoa != null && index != null) {
                                      widget.data.pessoas[index] = nova;
                                    } else {
                                      widget.data.pessoas.add(nova);
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

  Color _tipoColor(String tipo) {
    switch (tipo) {
      case 'Vítima':
        return PCPEColors.error;
      case 'Suspeito':
        return PCPEColors.warning;
      case 'Testemunha':
        return PCPEColors.info;
      case 'Comunicante':
        return PCPEColors.success;
      default:
        return PCPEColors.mediumGray;
    }
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
                        title: 'Pessoas Envolvidas',
                        icon: Icons.people_outline,
                      ),
                    ),
                    PCPEButton(
                      label: 'Adicionar',
                      icon: Icons.add,
                      small: true,
                      onPressed: () => _mostrarFormPessoa(),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (widget.data.pessoas.isEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    child: const Center(
                      child: Column(
                        children: [
                          Icon(Icons.person_add_disabled, size: 48, color: PCPEColors.lightGray),
                          SizedBox(height: 12),
                          Text(
                            'Nenhuma pessoa adicionada',
                            style: TextStyle(color: PCPEColors.mediumGray, fontSize: 14),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Adicione vítimas, suspeitos, testemunhas ou comunicantes.',
                            style: TextStyle(color: PCPEColors.lightGray, fontSize: 12),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  ...List.generate(widget.data.pessoas.length, (index) {
                    final p = widget.data.pessoas[index];
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
                          backgroundColor: _tipoColor(p.tipo).withValues(alpha: 0.15),
                          radius: 20,
                          child: Icon(
                            Icons.person,
                            color: _tipoColor(p.tipo),
                            size: 20,
                          ),
                        ),
                        title: Text(
                          p.nome,
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
                                color: _tipoColor(p.tipo).withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                p.tipo,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: _tipoColor(p.tipo),
                                ),
                              ),
                            ),
                            if (p.cpf.isNotEmpty) ...[
                              const SizedBox(width: 8),
                              Text(
                                p.cpf,
                                style: const TextStyle(fontSize: 12, color: PCPEColors.mediumGray),
                              ),
                            ],
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, size: 18, color: PCPEColors.primary),
                              onPressed: () => _mostrarFormPessoa(pessoa: p, index: index),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline, size: 18, color: PCPEColors.error),
                              onPressed: () {
                                setState(() {
                                  widget.data.pessoas.removeAt(index);
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