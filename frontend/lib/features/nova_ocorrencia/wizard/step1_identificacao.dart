import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../../design_system/design_system.dart';
import '../../../shared/widgets/pcpe_input.dart';
import '../../../shared/widgets/pcpe_card.dart';
import '../../../shared/widgets/pcpe_section_title.dart';
import 'ocorrencia_wizard_data.dart';

/// Etapa 1: Identificacao da Ocorrencia (F31).
///
/// Simplificada para uso em campo.
/// "Se o sistema ja sabe a informacao, nao perguntar ao usuario."
class Step1Identificacao extends StatefulWidget {
  final OcorrenciaWizardData data;
  final void Function() onChanged;
  const Step1Identificacao({super.key, required this.data, required this.onChanged});
  @override
  State<Step1Identificacao> createState() => _Step1IdentificacaoState();
}

class _Step1IdentificacaoState extends State<Step1Identificacao> {
  final _origens = ['Boletim de Ocorrencia (BO)', 'Disque-Denuncia', 'Policia Militar', 'Outra Unidade da Policia Civil', 'Delegado de Plantao', 'Hospital / Unidade de Saude', 'Comunicacao Direta', 'Outra Origem'];
  String _origemSelecionada = 'Boletim de Ocorrencia (BO)';
  final _classificacoes = ['Crime contra a Vida'];
  final _tipos = ['Homicidio Doloso', 'Homicidio Culposo', 'Latrocinio', 'Feminicidio', 'Lesao Corporal', 'Tentativa de Homicidio', 'Morte Suspeita'];
  final _equipes = ['Equipe Delta - Plantao A', 'Equipe Alfa - Plantao B', 'Equipe Bravo - Plantao C', 'Equipe Charlie - Plantao D'];

  late TextEditingController _boCtrl;
  late TextEditingController _outraOrigemCtrl;
  late TextEditingController _dataCtrl;
  late TextEditingController _horaCtrl;

  @override
  void initState() {
    super.initState();
    _boCtrl = TextEditingController(text: widget.data.numeroBO);
    _outraOrigemCtrl = TextEditingController(text: '');
    _dataCtrl = TextEditingController(text: widget.data.dataOcorrencia != null ? '${widget.data.dataOcorrencia!.day.toString().padLeft(2, '0')}/${widget.data.dataOcorrencia!.month.toString().padLeft(2, '0')}/${widget.data.dataOcorrencia!.year}' : '${DateTime.now().day.toString().padLeft(2, '0')}/${DateTime.now().month.toString().padLeft(2, '0')}/${DateTime.now().year}');
    _horaCtrl = TextEditingController(text: widget.data.horaOcorrencia != null ? '${widget.data.horaOcorrencia!.hour.toString().padLeft(2, '0')}:${widget.data.horaOcorrencia!.minute.toString().padLeft(2, '0')}' : '${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}');
  }

  @override
  void dispose() {
    _boCtrl.dispose();
    _outraOrigemCtrl.dispose();
    _dataCtrl.dispose();
    _horaCtrl.dispose();
    super.dispose();
  }

  void _selectDate() async {
    final d = await showDatePicker(context: context, initialDate: widget.data.dataOcorrencia ?? DateTime.now(), firstDate: DateTime(2020), lastDate: DateTime(2030));
    if (d != null) { widget.data.dataOcorrencia = d; _dataCtrl.text = '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}'; widget.onChanged(); }
  }

  void _selectTime() async {
    final t = await showTimePicker(context: context, initialTime: widget.data.horaOcorrencia ?? TimeOfDay.now());
    if (t != null) { widget.data.horaOcorrencia = t; _horaCtrl.text = '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}'; widget.onChanged(); }
  }

  Widget _buildDropdown(String label, String value, List<String> items, ValueChanged<String> onChanged) {
    return DropdownButtonFormField<String>(
      value: items.contains(value) ? value : items.first,
      decoration: InputDecoration(labelText: label, filled: true, fillColor: PCPEColors.cardGray, border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: PCPEColors.lightGray.withValues(alpha: 0.5))), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: PCPEColors.lightGray.withValues(alpha: 0.5))), focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: PCPEColors.primary, width: 2)), contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14)),
      items: items.map((i) => DropdownMenuItem(value: i, child: Text(i, style: const TextStyle(fontSize: 14)))).toList(),
      onChanged: (v) { if (v != null) onChanged(v); },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;
    final showBO = _origemSelecionada == 'Boletim de Ocorrencia (BO)';
    final showOutraOrigem = _origemSelecionada == 'Outra Origem';

    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 12 : 16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        // ── Protocolo (somente leitura) ────────────────────────
        PCPECard(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const PCPESectionTitle(title: 'Protocolo', icon: Icons.qr_code_2, subtitle: 'Gerado automaticamente pelo sistema.'),
            const SizedBox(height: 12),
            PCPEInput(label: 'Protocolo', prefixIcon: Icons.shield, controller: TextEditingController(text: widget.data.numeroProtocolo), readOnly: true),
          ]),
        ),
        const SizedBox(height: 12),
        // ── Origem do Acionamento ───────────────────────────────
        PCPECard(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const PCPESectionTitle(title: 'Origem do Acionamento', icon: Icons.phone_in_talk, subtitle: 'Selecione como a equipe foi acionada.'),
            const SizedBox(height: 12),
            _buildDropdown('Origem', _origemSelecionada, _origens, (v) => setState(() => _origemSelecionada = v)),
            const SizedBox(height: 12),
            AnimatedCrossFade(firstChild: const SizedBox.shrink(), secondChild: PCPEInput(label: 'Numero do BO', hint: 'Informe o numero do Boletim de Ocorrencia', prefixIcon: Icons.tag, controller: _boCtrl, onChanged: (v) { widget.data.numeroBO = v; widget.onChanged(); }), crossFadeState: showBO ? CrossFadeState.showSecond : CrossFadeState.showFirst, duration: const Duration(milliseconds: 250)),
            AnimatedCrossFade(firstChild: const SizedBox.shrink(), secondChild: PCPEInput(label: 'Descreva a origem do acionamento', hint: 'Informe a origem...', prefixIcon: Icons.edit, controller: _outraOrigemCtrl, maxLines: 2, onChanged: (v) { widget.data.observacoesGerais = v; widget.onChanged(); }), crossFadeState: showOutraOrigem ? CrossFadeState.showSecond : CrossFadeState.showFirst, duration: const Duration(milliseconds: 250)),
          ]),
        ),
        const SizedBox(height: 12),
        // ── Classificacao + Tipo ────────────────────────────────
        PCPECard(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const PCPESectionTitle(title: 'Classificacao', icon: Icons.category_outlined, subtitle: 'Crime contra a Vida — unica categoria nesta versao.'),
            const SizedBox(height: 12),
            _buildDropdown('Classificacao', widget.data.natureza, _classificacoes, (v) { widget.data.natureza = v; widget.onChanged(); }),
            const SizedBox(height: 12),
            _buildDropdown('Tipo da Ocorrencia', widget.data.tipoOcorrencia, _tipos, (v) { widget.data.tipoOcorrencia = v; widget.onChanged(); }),
          ]),
        ),
        const SizedBox(height: 12),
        // ── Data + Hora ─────────────────────────────────────────
        PCPECard(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const PCPESectionTitle(title: 'Data e Hora', icon: Icons.access_time, subtitle: 'Preenchimento automatico. Toque para alterar.'),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(child: InkWell(onTap: _selectDate, borderRadius: BorderRadius.circular(10), child: PCPEInput(label: 'Data', prefixIcon: Icons.calendar_today, readOnly: true, controller: _dataCtrl, onTap: _selectDate))),
              const SizedBox(width: 12),
              Expanded(child: InkWell(onTap: _selectTime, borderRadius: BorderRadius.circular(10), child: PCPEInput(label: 'Hora', prefixIcon: Icons.access_time, readOnly: true, controller: _horaCtrl, onTap: _selectTime))),
            ]),
          ]),
        ),
        const SizedBox(height: 12),
        // ── Dados Institucionais (somente leitura) ──────────────
        PCPECard(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const PCPESectionTitle(title: 'Dados Institucionais', icon: Icons.business, subtitle: 'Obtidos automaticamente do perfil do usuario.'),
            const SizedBox(height: 12),
            _readOnlyField('Diretoria', 'DIRESP'),
            _readOnlyField('Divisao', 'DHPP'),
            _readOnlyField('Unidade', '7ª Delegacia de Policia de Homicidios'),
            const SizedBox(height: 4),
            Text('Dados obtidos automaticamente do perfil do usuario.', style: TextStyle(fontSize: 10, color: PCPEColors.mediumGray, fontStyle: FontStyle.italic)),
          ]),
        ),
        const SizedBox(height: 12),
        // ── Equipe Responsavel (unico campo selecionavel) ──────
        PCPECard(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const PCPESectionTitle(title: 'Equipe Responsavel', icon: Icons.groups, subtitle: 'Unico campo que pode variar conforme a escala.'),
            const SizedBox(height: 12),
            _buildDropdown('Equipe', widget.data.equipeResponsavel, _equipes, (v) { widget.data.equipeResponsavel = v; widget.onChanged(); }),
          ]),
        ),
        // ── Responsavel (informativo) ───────────────────────────
        const SizedBox(height: 8),
        PCPECard(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const PCPESectionTitle(title: 'Responsavel pelo Registro', icon: Icons.person, subtitle: 'Identificado automaticamente.'),
            const SizedBox(height: 10),
            _readOnlyField('Nome', 'Ag. Fabio Fernandes'),
            _readOnlyField('Matricula', '000.000-0'),
            _readOnlyField('Cargo', 'Agente de Policia Civil'),
          ]),
        ),
        const SizedBox(height: 24),
      ]),
    );
  }

  Widget _readOnlyField(String label, String value) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(children: [
      SizedBox(width: 100, child: Text('$label:', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: PCPEColors.darkGray))),
      Expanded(child: Text(value, style: const TextStyle(fontSize: 13, color: PCPEColors.black))),
    ]),
  );
}