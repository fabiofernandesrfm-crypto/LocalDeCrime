import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../../design_system/design_system.dart';
import '../../../shared/widgets/pcpe_card.dart';
import '../../../shared/widgets/pcpe_section_title.dart';
import '../../../shared/widgets/narrative_editor_widget.dart';
import 'ocorrencia_wizard_data.dart';

/// Etapa 5: Narrativa (F36) — Assistente Inteligente.
///
/// Condições do Local + Apoio Acionado + Providências + Resumo Visual + Narrativa.
class Step7Narrativa extends StatefulWidget {
  final OcorrenciaWizardData data;
  final void Function() onChanged;
  const Step7Narrativa({super.key, required this.data, required this.onChanged});
  @override
  State<Step7Narrativa> createState() => _Step7NarrativaState();
}

class _Step7NarrativaState extends State<Step7Narrativa> {
  late TextEditingController _narrativaCtrl;

  // Multi select sets (preparados para evolução futura)
  final Set<String> _condicoes = {};
  final Set<String> _providencias = {};
  final Set<String> _apoio = {};

  static const _opcoesCondicoes = [
    'Ensolarado','Nublado','Chuva','Garoa','Ventania','Dia','Noite',
    'Iluminacao adequada','Iluminacao precaria','Sem iluminacao',
    'Local preservado','Local parcialmente preservado','Local nao preservado',
    'Grande circulacao de pessoas','Local isolado',
  ];
  static const _opcoesProvidencias = [
    'Isolamento do local','Acionamento da pericia','Registro fotografico realizado',
    'Coleta de vestigios','Coleta de depoimentos','Encaminhamento ao IML',
    'Comunicacao ao Delegado','Comunicacao ao Plantão',
    'Apreensao de objetos','Apreensao de veiculos','Preservacao da cena',
    'Outra providencia',
  ];
  static const _opcoesApoio = [
    'Policia Civil','Policia Militar','Pericia Criminal','IML',
    'Corpo de Bombeiros','SAMU','Guarda Municipal','Outro',
  ];

  @override
  void initState() {
    super.initState();
    _narrativaCtrl = TextEditingController(text: widget.data.narrativa);
    // Parse existing providencias text into checkboxes
    if (widget.data.providenciasAdotadas.isNotEmpty) {
      for (final o in _opcoesProvidencias) {
        if (widget.data.providenciasAdotadas.toLowerCase().contains(o.toLowerCase())) {
          _providencias.add(o);
        }
      }
    }
  }

  @override
  void dispose() {
    _narrativaCtrl.dispose();
    super.dispose();
  }

  void _syncData() {
    widget.data.narrativa = _narrativaCtrl.text;
    widget.data.providenciasAdotadas = _providencias.isNotEmpty ? _providencias.join('; ') : '';
    widget.onChanged();
  }

  Widget _chipsCard(String title, IconData icon, String subtitle, List<String> options, Set<String> selected) {
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;
    return PCPECard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      PCPESectionTitle(title: title, icon: icon, subtitle: subtitle),
      const SizedBox(height: 10),
      Wrap(spacing: 4, runSpacing: 4, children: options.map((o) => FilterChip(
        label: Text(o, style: TextStyle(fontSize: isMobile ? 10 : 11, color: selected.contains(o) ? PCPEColors.pureWhite : PCPEColors.darkGray)),
        selected: selected.contains(o),
        selectedColor: PCPEColors.primary,
        backgroundColor: PCPEColors.cardGray,
        checkmarkColor: PCPEColors.pureWhite,
        onSelected: (v) {
          setState(() {
            v ? selected.add(o) : selected.remove(o);
          });
          _syncData();
        },
        visualDensity: VisualDensity.compact,
      )).toList()),
    ]));
  }

  Widget _buildResumo() {
    final todos = <String>[
      ..._condicoes,
      ..._providencias,
      ..._apoio,
    ];
    if (todos.isEmpty) return const SizedBox.shrink();
    return PCPECard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const PCPESectionTitle(title: 'Resumo das Selecoes', icon: Icons.summarize, subtitle: 'Use como auxilio na elaboracao da narrativa'),
        const SizedBox(height: 8),
        Wrap(spacing: 4, runSpacing: 4, children: todos.map((t) => Chip(
          avatar: const Icon(Icons.check, size: 14, color: PCPEColors.success),
          label: Text(t, style: const TextStyle(fontSize: 11)),
          backgroundColor: PCPEColors.successLight,
          visualDensity: VisualDensity.compact,
        )).toList()),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final breakpoints = ResponsiveBreakpoints.of(context);
    final isDesktop = breakpoints.isDesktop;
    final isMobile = breakpoints.isMobile;
    final pad = isMobile ? 12.0 : 16.0;
    final gap = isMobile ? 12.0 : 16.0;

    return SingleChildScrollView(
      padding: EdgeInsets.all(pad),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        // ── Condições do Local ────────────────────────────────
        _chipsCard('Condicoes do Local', Icons.wb_sunny, 'Marque as condicoes observadas', _opcoesCondicoes, _condicoes),
        SizedBox(height: gap),
        // ── Apoio Acionado ────────────────────────────────────
        _chipsCard('Apoio Acionado', Icons.local_police, 'Orgaos/equipes acionados', _opcoesApoio, _apoio),
        SizedBox(height: gap),
        // ── Providências Adotadas ─────────────────────────────
        _chipsCard('Providencias Adotadas', Icons.checklist, 'Medidas tomadas pela equipe', _opcoesProvidencias, _providencias),
        SizedBox(height: gap),
        // ── Resumo Visual ─────────────────────────────────────
        _buildResumo(),
        SizedBox(height: gap),
        // ── Narrativa do Fato ─────────────────────────────────
        PCPECard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const PCPESectionTitle(title: 'Narrativa do Fato', icon: Icons.edit_note, subtitle: 'Descreva detalhadamente a dinamica do evento'),
          SizedBox(height: gap),
          NarrativeEditorWidget(textController: _narrativaCtrl, hint: 'Descreva detalhadamente os fatos ocorridos, incluindo data, hora, local, pessoas envolvidas, dinamica do evento e demais informacoes relevantes para a investigacao...', maxLines: 12, onChanged: _syncData),
        ])),
        SizedBox(height: gap * 1.5),
      ]),
    );
  }
}