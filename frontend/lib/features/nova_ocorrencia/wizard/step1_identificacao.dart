import 'package:flutter/material.dart';
import '../../../design_system/design_system.dart';
import '../../../shared/widgets/pcpe_input.dart';
import '../../../shared/widgets/pcpe_card.dart';
import '../../../shared/widgets/pcpe_section_title.dart';
import 'ocorrencia_wizard_data.dart';

/// Etapa 1: Identificação da Ocorrência
class Step1Identificacao extends StatelessWidget {
  final OcorrenciaWizardData data;
  final void Function() onChanged;

  const Step1Identificacao({
    super.key,
    required this.data,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Card: Protocolo e Identificação
          PCPECard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const PCPESectionTitle(
                  title: 'Identificação do Registro',
                  icon: Icons.description_outlined,
                ),
                const SizedBox(height: 16),
                // Protocolo (somente leitura)
                PCPEInput(
                  label: 'Nº do Protocolo',
                  prefixIcon: Icons.qr_code_2,
                  controller: TextEditingController(text: data.numeroProtocolo),
                  readOnly: true,
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: PCPEInput(
                        label: 'Nº do BO',
                        hint: 'Boletim de Ocorrência',
                        prefixIcon: Icons.tag,
                        controller: TextEditingController(text: data.numeroBO),
                        onChanged: (v) {
                          data.numeroBO = v;
                          onChanged();
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: PCPEInput(
                        label: 'Nº do Inquérito',
                        hint: 'Inquérito Policial',
                        prefixIcon: Icons.gavel,
                        controller: TextEditingController(text: data.numeroInquerito),
                        onChanged: (v) {
                          data.numeroInquerito = v;
                          onChanged();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Card: Classificação
          PCPECard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const PCPESectionTitle(
                  title: 'Classificação da Ocorrência',
                  icon: Icons.category_outlined,
                ),
                const SizedBox(height: 16),
                _buildDropdown(
                  label: 'Natureza',
                  value: data.natureza,
                  items: const [
                    'Crime contra a vida',
                    'Crime contra o patrimônio',
                    'Crime contra a dignidade sexual',
                    'Tráfico de entorpecentes',
                    'Crime ambiental',
                    'Crime cibernético',
                    'Outros',
                  ],
                  onChanged: (v) {
                    data.natureza = v;
                    onChanged();
                  },
                ),
                const SizedBox(height: 14),
                _buildDropdown(
                  label: 'Tipo da Ocorrência',
                  value: data.tipoOcorrencia,
                  items: const [
                    'Homicídio Doloso',
                    'Homicídio Culposo',
                    'Latrocínio',
                    'Feminicídio',
                    'Lesão Corporal',
                    'Tentativa de Homicídio',
                    'Morte Suspeita',
                  ],
                  onChanged: (v) {
                    data.tipoOcorrencia = v;
                    onChanged();
                  },
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => _selectDate(context),
                        borderRadius: BorderRadius.circular(10),
                        child: PCPEInput(
                          label: 'Data',
                          prefixIcon: Icons.calendar_today,
                          readOnly: true,
                          controller: TextEditingController(
                            text: data.dataOcorrencia != null
                                ? '${data.dataOcorrencia!.day.toString().padLeft(2, '0')}/${data.dataOcorrencia!.month.toString().padLeft(2, '0')}/${data.dataOcorrencia!.year}'
                                : '',
                          ),
                          onTap: () => _selectDate(context),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: InkWell(
                        onTap: () => _selectTime(context),
                        borderRadius: BorderRadius.circular(10),
                        child: PCPEInput(
                          label: 'Hora',
                          prefixIcon: Icons.access_time,
                          readOnly: true,
                          controller: TextEditingController(
                            text: data.horaOcorrencia != null
                                ? '${data.horaOcorrencia!.hour.toString().padLeft(2, '0')}:${data.horaOcorrencia!.minute.toString().padLeft(2, '0')}'
                                : '',
                          ),
                          onTap: () => _selectTime(context),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Card: Status e Prioridade
          PCPECard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const PCPESectionTitle(
                  title: 'Prioridade e Responsáveis',
                  icon: Icons.shield_outlined,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildDropdown(
                        label: 'Prioridade',
                        value: data.prioridade,
                        items: const ['Baixa', 'Média', 'Alta', 'Urgente'],
                        onChanged: (v) {
                          data.prioridade = v;
                          onChanged();
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildDropdown(
                        label: 'Status',
                        value: data.status,
                        items: const ['Em andamento', 'Concluído', 'Arquivado', 'Pendente'],
                        onChanged: (v) {
                          data.status = v;
                          onChanged();
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                _buildDropdown(
                  label: 'Unidade Responsável',
                  value: data.unidadeResponsavel,
                  items: const [
                    'DTI – UNISA',
                    'DEPATRI - Departamento de Patrimônio',
                    'DENARC - Departamento de Narcóticos',
                    'DECASP - Departamento de Capturas',
                  ],
                  onChanged: (v) {
                    data.unidadeResponsavel = v;
                    onChanged();
                  },
                ),
                const SizedBox(height: 14),
                _buildDropdown(
                  label: 'Equipe Responsável',
                  value: data.equipeResponsavel,
                  items: const [
                    'Equipe Delta - Plantão A',
                    'Equipe Alfa - Plantão B',
                    'Equipe Bravo - Plantão C',
                    'Equipe Charlie - Plantão D',
                  ],
                  onChanged: (v) {
                    data.equipeResponsavel = v;
                    onChanged();
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

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: data.dataOcorrencia ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: PCPEColors.primary,
              onPrimary: PCPEColors.pureWhite,
              surface: PCPEColors.pureWhite,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      data.dataOcorrencia = picked;
      onChanged();
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: data.horaOcorrencia ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: PCPEColors.primary,
              onPrimary: PCPEColors.pureWhite,
              surface: PCPEColors.pureWhite,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      data.horaOcorrencia = picked;
      onChanged();
    }
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required void Function(String) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      style: const TextStyle(color: PCPEColors.black, fontSize: 14),
      decoration: InputDecoration(
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
      ),
      items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
      onChanged: (v) => onChanged(v!),
      icon: const Icon(Icons.keyboard_arrow_down, color: PCPEColors.mediumGray),
      isExpanded: true,
    );
  }
}