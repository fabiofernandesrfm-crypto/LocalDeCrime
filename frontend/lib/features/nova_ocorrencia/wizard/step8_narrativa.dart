import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../../design_system/design_system.dart';
import '../../../shared/widgets/pcpe_input.dart';
import '../../../shared/widgets/pcpe_card.dart';
import '../../../shared/widgets/pcpe_section_title.dart';
import '../../../shared/widgets/narrative_editor_widget.dart';
import 'ocorrencia_wizard_data.dart';

/// Etapa 8: Narrativa
///
/// Layout responsivo:
/// - Desktop (>= DESKTOP): Narrativa (largura total), Observações e Providências lado a lado
/// - Tablet (TABLET): Todas as seções empilhadas, cards mais largos
/// - Mobile (MOBILE): Todas as seções empilhadas, padding reduzido
class Step8Narrativa extends StatefulWidget {
  final OcorrenciaWizardData data;
  final void Function() onChanged;

  const Step8Narrativa({
    super.key,
    required this.data,
    required this.onChanged,
  });

  @override
  State<Step8Narrativa> createState() => _Step8NarrativaState();
}

class _Step8NarrativaState extends State<Step8Narrativa> {
  late TextEditingController _narrativaController;
  late TextEditingController _observacoesController;
  late TextEditingController _providenciasController;

  @override
  void initState() {
    super.initState();
    _narrativaController = TextEditingController(text: widget.data.narrativa);
    _observacoesController =
        TextEditingController(text: widget.data.observacoesGerais);
    _providenciasController =
        TextEditingController(text: widget.data.providenciasAdotadas);
  }

  @override
  void dispose() {
    _narrativaController.dispose();
    _observacoesController.dispose();
    _providenciasController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final breakpoints = ResponsiveBreakpoints.of(context);
    final isDesktop = breakpoints.isDesktop;
    final isMobile = breakpoints.isMobile;
    final horizontalPadding = isMobile ? 12.0 : 16.0;
    final verticalSpacing = isMobile ? 12.0 : 16.0;

    return SingleChildScrollView(
      padding: EdgeInsets.all(horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Card: Narrativa Principal (Multimodal)
          PCPECard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const PCPESectionTitle(
                  title: 'Narrativa do Fato',
                  icon: Icons.edit_note,
                  subtitle: 'Descreva detalhadamente a dinâmica do evento',
                ),
                SizedBox(height: verticalSpacing),
                NarrativeEditorWidget(
                  textController: _narrativaController,
                  hint: 'Descreva detalhadamente os fatos ocorridos, '
                      'incluindo data, hora, local, pessoas envolvidas, '
                      'dinâmica do evento e demais informações relevantes '
                      'para a investigação...\n\n'
                      'Exemplo:\n'
                      'No dia X, por volta das Y horas, a equipe de plantão '
                      'foi acionada via CIODS para atender a uma ocorrência '
                      'no endereço...',
                  maxLines: 12,
                  onChanged: () {
                    widget.data.narrativa = _narrativaController.text;
                    widget.onChanged();
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: verticalSpacing),
          // Observações e Providências:
          // Desktop: lado a lado  |  Tablet/Mobile: empilhados
          if (isDesktop)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _buildObservacoesCard()),
                const SizedBox(width: 16),
                Expanded(child: _buildProvidenciasCard()),
              ],
            )
          else ...[
            _buildObservacoesCard(),
            SizedBox(height: verticalSpacing),
            _buildProvidenciasCard(),
          ],
          SizedBox(height: verticalSpacing * 1.5),
        ],
      ),
    );
  }

  /// Card: Observações Complementares
  Widget _buildObservacoesCard() {
    return PCPECard(
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
            controller: _observacoesController,
            onChanged: (v) {
              widget.data.observacoesGerais = v;
              widget.onChanged();
            },
          ),
        ],
      ),
    );
  }

  /// Card: Providências Adotadas
  Widget _buildProvidenciasCard() {
    return PCPECard(
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
            controller: _providenciasController,
            onChanged: (v) {
              widget.data.providenciasAdotadas = v;
              widget.onChanged();
            },
          ),
        ],
      ),
    );
  }
}

