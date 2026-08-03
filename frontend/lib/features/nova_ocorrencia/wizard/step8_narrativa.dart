import 'package:flutter/material.dart';
import '../../../shared/widgets/pcpe_input.dart';
import '../../../shared/widgets/pcpe_card.dart';
import '../../../shared/widgets/pcpe_section_title.dart';
import 'ocorrencia_wizard_data.dart';

/// Etapa 8: Narrativa
class Step8Narrativa extends StatelessWidget {
  final OcorrenciaWizardData data;
  final void Function() onChanged;

  const Step8Narrativa({
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
          // Card: Narrativa Principal
          PCPECard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const PCPESectionTitle(
                  title: 'Narrativa do Fato',
                  icon: Icons.edit_note,
                  subtitle: 'Descreva detalhadamente a dinâmica do evento',
                ),
                const SizedBox(height: 16),
                PCPEInput(
                  label: 'Narrativa',
                  hint: 'Descreva detalhadamente os fatos ocorridos, '
                      'incluindo data, hora, local, pessoas envolvidas, '
                      'dinâmica do evento e demais informações relevantes '
                      'para a investigação...\n\n'
                      'Exemplo:\n'
                      'No dia X, por volta das Y horas, a equipe de plantão '
                      'foi acionada via CIODS para atender a uma ocorrência '
                      'no endereço...',
                  prefixIcon: Icons.description_outlined,
                  maxLines: 12,
                  controller: TextEditingController(text: data.narrativa),
                  onChanged: (v) {
                    data.narrativa = v;
                    onChanged();
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Card: Observações
          PCPECard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const PCPESectionTitle(
                  title: 'Observações Complementares',
                  icon: Icons.notes,
                  subtitle: 'Informações adicionais relevantes',
                ),
                const SizedBox(height: 16),
                PCPEInput(
                  label: 'Observações',
                  hint: 'Registre observações complementares, '
                      'condições climáticas, iluminação, '
                      'fluxo de pessoas no local, etc...',
                  prefixIcon: Icons.info_outline,
                  maxLines: 6,
                  controller: TextEditingController(text: data.observacoesGerais),
                  onChanged: (v) {
                    data.observacoesGerais = v;
                    onChanged();
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Card: Providências
          PCPECard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const PCPESectionTitle(
                  title: 'Providências Adotadas',
                  icon: Icons.checklist,
                  subtitle: 'Medidas tomadas pela equipe no local',
                ),
                const SizedBox(height: 16),
                PCPEInput(
                  label: 'Providências',
                  hint: 'Liste as providências já adotadas:\n'
                      '• Isolamento do local\n'
                      '• Acionamento da perícia\n'
                      '• Coleta de depoimentos\n'
                      '• Encaminhamento ao IML\n'
                      '• Comunicação à autoridade competente\n'
                      '• Outras medidas...',
                  prefixIcon: Icons.assignment_turned_in,
                  maxLines: 6,
                  controller: TextEditingController(text: data.providenciasAdotadas),
                  onChanged: (v) {
                    data.providenciasAdotadas = v;
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
}