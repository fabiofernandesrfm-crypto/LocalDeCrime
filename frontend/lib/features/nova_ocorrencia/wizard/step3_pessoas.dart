import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../design_system/design_system.dart';
import '../../../shared/widgets/pcpe_input.dart';
import '../../../shared/widgets/pcpe_card.dart';
import '../../../shared/widgets/pcpe_button.dart';
import '../../../shared/widgets/media_capture_section.dart';
import '../../../shared/widgets/narrative_editor_widget.dart';
import 'ocorrencia_wizard_data.dart';

/// Etapa 3: Pessoas Envolvidas (F33.2).
class Step3Pessoas extends StatefulWidget {
  final OcorrenciaWizardData data;
  final void Function() onChanged;
  const Step3Pessoas({super.key, required this.data, required this.onChanged});
  @override
  State<Step3Pessoas> createState() => _Step3PessoasState();
}

class _Step3PessoasState extends State<Step3Pessoas> {
  final _tiposPessoa = ['Vítima', 'Suspeito', 'Testemunha', 'Noticiante'];

  void _mostrarFormPessoa({PessoaEnvolvida? pessoa, int? index}) {
    // GPS local state (F38.7 — mesma logica do vestigio)
    String? _gpsLat = pessoa?.gpsVitimaLat;
    String? _gpsLng = pessoa?.gpsVitimaLng;

    final nomeCtrl = TextEditingController(text: pessoa?.nome ?? '');
    final cpfCtrl = TextEditingController(text: pessoa?.cpf ?? '');
    final rgCtrl = TextEditingController(text: pessoa?.rg ?? '');
    final orgaoCtrl = TextEditingController(text: pessoa?.orgaoExpedidor ?? '');
    final natCtrl = TextEditingController(text: pessoa?.naturalidade ?? '');
    final filCtrl = TextEditingController(text: pessoa?.filiacao ?? '');
    final telCtrl = TextEditingController(text: pessoa?.telefone ?? '');
    final endCtrl = TextEditingController(text: pessoa?.endereco ?? '');
    final nicCtrl = TextEditingController(text: pessoa?.nic ?? '');
    final obsCtrl = TextEditingController(text: pessoa?.observacoes ?? '');
    String tipo = pessoa?.tipo ?? 'Vítima';
    DateTime? dataNasc = pessoa?.dataNascimento;
    bool vitimaNaoId = pessoa?.vitimaNaoIdentificada ?? false;
    Map<String, String> caract = pessoa?.caracteristicas ?? {};
    final List<String> tels = List.from(pessoa?.telefones ?? []);
    final List<String> ends = List.from(pessoa?.enderecos ?? []);

    showModalBottomSheet(
      context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(builder: (ctx, setModalState) {
        final isVitima = tipo == 'Vítima';
        return Container(
          height: MediaQuery.of(context).size.height * 0.9,
          decoration: const BoxDecoration(color: PCPEColors.pureWhite, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
          child: Column(children: [
            Container(margin: const EdgeInsets.symmetric(vertical: 12), width: 40, height: 4, decoration: BoxDecoration(color: PCPEColors.lightGray, borderRadius: BorderRadius.circular(2))),
            Expanded(child: SingleChildScrollView(padding: const EdgeInsets.fromLTRB(24, 8, 24, 24), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              Text(pessoa == null ? 'Nova Pessoa' : 'Editar Pessoa', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: PCPEColors.black)),
              const SizedBox(height: 20),
              _dd(tipo, _tiposPessoa, 'Tipo de Envolvimento', (v) => setModalState(() { tipo = v!; if (v != 'Vítima') vitimaNaoId = false; })),
              const SizedBox(height: 14),
              if (isVitima) CheckboxListTile(value: vitimaNaoId, onChanged: (v) => setModalState(() => vitimaNaoId = v ?? false), title: const Text('Vítima não identificada', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)), activeColor: PCPEColors.warning, contentPadding: EdgeInsets.zero),
              // Documento OCR (F33.1: reposicionado antes dos campos, oculto se vitima nao id)
              if (!vitimaNaoId) ...[
                const SizedBox(height: 12),
                Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: PCPEColors.primarySoft, borderRadius: BorderRadius.circular(10)), child: Column(children: [
                  const Text('Documento de Identificação', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: PCPEColors.black)),
                  const SizedBox(height: 8),
                  Row(children: [
                    Expanded(child: PCPEButton(label: 'Capturar Documento', icon: Icons.camera_alt, outlined: true, onPressed: () { _ocrMock(setModalState, nomeCtrl, cpfCtrl, rgCtrl, orgaoCtrl, dataNasc, (d) => setModalState(() => dataNasc = d), natCtrl, filCtrl); })),
                    const SizedBox(width: 8),
                    Expanded(child: PCPEButton(label: 'Selecionar Imagem', icon: Icons.image, outlined: true, onPressed: () { ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(content: Text('Seleção de imagem simulada.'), backgroundColor: PCPEColors.darkGray)); })),
                  ]),
                ])),
              ],
              if (!vitimaNaoId) ...[
                const SizedBox(height: 8),
                PCPEInput(label: 'Nome', hint: 'Nome completo', prefixIcon: Icons.person, controller: nomeCtrl),
                const SizedBox(height: 10),
                Row(children: [Expanded(child: PCPEInput(label: 'CPF', hint: '000.000.000-00', prefixIcon: Icons.badge, controller: cpfCtrl)), const SizedBox(width: 10), Expanded(child: PCPEInput(label: 'RG', hint: '00.000.000-0', prefixIcon: Icons.credit_card, controller: rgCtrl))]),
                const SizedBox(height: 10),
                Row(children: [Expanded(child: PCPEInput(label: 'Órgão Expedidor', hint: 'SSP', prefixIcon: Icons.account_balance, controller: orgaoCtrl)), const SizedBox(width: 10), Expanded(child: PCPEInput(label: 'Naturalidade', hint: 'Cidade/UF', prefixIcon: Icons.flag, controller: natCtrl))]),
                const SizedBox(height: 10),
                PCPEInput(label: 'Filiação', hint: 'Pais', prefixIcon: Icons.family_restroom, controller: filCtrl),
                const SizedBox(height: 10),
                InkWell(onTap: () async { final d = await showDatePicker(context: ctx, initialDate: dataNasc ?? DateTime(1990), firstDate: DateTime(1900), lastDate: DateTime.now()); if (d != null) setModalState(() => dataNasc = d); }, child: PCPEInput(label: 'Data de Nascimento', prefixIcon: Icons.cake, readOnly: true, controller: TextEditingController(text: dataNasc != null ? '${dataNasc!.day.toString().padLeft(2, '0')}/${dataNasc!.month.toString().padLeft(2, '0')}/${dataNasc!.year}' : ''), onTap: () async { final d = await showDatePicker(context: ctx, initialDate: dataNasc ?? DateTime(1990), firstDate: DateTime(1900), lastDate: DateTime.now()); if (d != null) setModalState(() => dataNasc = d); })),
              ],
              if (vitimaNaoId && isVitima) ...[const SizedBox(height: 10), _buildCaracteristicas(caract, setModalState)],
              if (isVitima) ...[const SizedBox(height: 10), PCPEInput(label: 'NIC', hint: '7 dígitos', prefixIcon: Icons.numbers, controller: nicCtrl, keyboardType: TextInputType.number, maxLength: 7)],
              const SizedBox(height: 14),
              Text('Telefones: ${tels.length}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
              ...tels.asMap().entries.map((e) { return Row(children: [Expanded(child: PCPEInput(hint: '(81) 99999-0000', prefixIcon: Icons.phone, controller: TextEditingController(text: e.value), onChanged: (v) => tels[e.key] = v)), IconButton(icon: const Icon(Icons.delete, size: 18, color: PCPEColors.error), onPressed: () => setModalState(() => tels.removeAt(e.key)))]); }).toList(),
              PCPEButton(label: '+ Adicionar telefone', icon: Icons.add, outlined: true, fullWidth: true, onPressed: () => setModalState(() => tels.add(''))),
              const SizedBox(height: 10),
              Text('Endereços: ${ends.length}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
              ...ends.asMap().entries.map((e) { return Row(children: [Expanded(child: PCPEInput(hint: 'Endereço', prefixIcon: Icons.home, controller: TextEditingController(text: e.value), onChanged: (v) => ends[e.key] = v)), IconButton(icon: const Icon(Icons.delete, size: 18, color: PCPEColors.error), onPressed: () => setModalState(() => ends.removeAt(e.key)))]); }).toList(),
              PCPEButton(label: '+ Adicionar endereço', icon: Icons.add, outlined: true, fullWidth: true, onPressed: () => setModalState(() => ends.add(''))),
              if (isVitima) ...[
                const SizedBox(height: 14),
                PCPEButton(label: _gpsLat != null ? 'Localização da vítima registrada' : '📍 Registrar localização da vítima', icon: Icons.gps_fixed, fullWidth: true, backgroundColor: _gpsLat != null ? PCPEColors.success : PCPEColors.primary, onPressed: () { setModalState(() { _gpsLat = '-8.047620'; _gpsLng = '-34.877030'; }); HapticFeedback.mediumImpact(); }),
                if (_gpsLat != null) ...[
                  const SizedBox(height: 8),
                  Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: PCPEColors.successLight, borderRadius: BorderRadius.circular(8)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    _gpsInfo('Endereço aproximado', 'Av. Conselheiro Aguiar, 4520 - Boa Viagem, Recife/PE'),
                    _gpsInfo('Latitude', _gpsLat!), _gpsInfo('Longitude', _gpsLng!),
                    _gpsInfo('Precisão', '3 metros'), _gpsInfo('Data/Hora', '07/08/2026 11:10'),
                    const SizedBox(height: 6),
                    PCPEButton(label: 'Atualizar localização', icon: Icons.refresh, outlined: true, small: true, height: 32, onPressed: () { setModalState(() { _gpsLat = null; _gpsLng = null; }); }),
                  ])),
                ],
              ],
              const SizedBox(height: 14),
              NarrativeEditorWidget(textController: obsCtrl, hint: 'Informações adicionais sobre a pessoa...'),
              const SizedBox(height: 20),
              Row(children: [Expanded(child: PCPEButton(label: 'Cancelar', outlined: true, fullWidth: true, onPressed: () => Navigator.pop(ctx))), const SizedBox(width: 12), Expanded(child: PCPEButton(label: pessoa == null ? 'Adicionar' : 'Salvar', icon: Icons.save, fullWidth: true, onPressed: () {
                final novo = PessoaEnvolvida(nome: nomeCtrl.text, cpf: cpfCtrl.text, rg: rgCtrl.text, orgaoExpedidor: orgaoCtrl.text, naturalidade: natCtrl.text, filiacao: filCtrl.text, dataNascimento: dataNasc, telefone: telCtrl.text, endereco: endCtrl.text, tipo: tipo, nic: nicCtrl.text, observacoes: obsCtrl.text, vitimaNaoIdentificada: vitimaNaoId, caracteristicas: caract, telefones: tels, enderecos: ends, midias: pessoa?.midias ?? [], documentos: pessoa?.documentos ?? [], gpsVitimaLat: _gpsLat, gpsVitimaLng: _gpsLng);
                if (pessoa != null && index != null) { widget.data.pessoas[index] = novo; } else { widget.data.pessoas.add(novo); }
                widget.onChanged(); Navigator.pop(ctx);
              }))]),
            ]))),
          ]),
        );
      }),
    );
  }

  Widget _buildCaracteristicas(Map<String, String> c, void Function(void Function()) ss) {
    final sexos = ['Masculino', 'Feminino', 'Não identificado'];
    final faixas = ['0-12', '13-17', '18-25', '26-35', '36-50', '51+', 'Não identificada'];
    final cores = ['Branca', 'Parda', 'Preta', 'Indígena', 'Amarela', 'Não identificada'];
    final alturas = ['Até 1,50m', '1,51-1,60m', '1,61-1,70m', '1,71-1,80m', 'Acima de 1,80m', 'Não identificada'];
    final portes = ['Magro', 'Médio', 'Forte', 'Obeso', 'Não identificado'];
    final cabelos = ['Preto', 'Castanho', 'Loiro', 'Ruivo', 'Grisalho', 'Careca', 'Não identificado'];
    final marcas = ['Tatuagem', 'Cicatriz', 'Deficiência', 'Piercing', 'Nenhuma aparente'];
    final vest = ['Camisa', 'Camiseta', 'Calça', 'Shorts', 'Vestido', 'Uniforme', 'Não identificada'];
    List<String> marcasSel = c['marcas']?.split(',') ?? [];
    if (marcasSel.isEmpty && c['marcas'] != null) marcasSel = [c['marcas']!];
    List<String> vestSel = c['vest']?.split(',') ?? [];
    if (vestSel.isEmpty && c['vest'] != null) vestSel = [c['vest']!];
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Características da vítima', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
      const SizedBox(height: 8),
      _chipRow('Sexo aparente', sexos, c['sexo'], (v) => ss(() => c['sexo'] = v)),
      _chipRow('Faixa etária', faixas, c['faixa'], (v) => ss(() => c['faixa'] = v)),
      _chipRow('Cor/Raça', cores, c['cor'], (v) => ss(() => c['cor'] = v)),
      _chipRow('Altura aprox.', alturas, c['altura'], (v) => ss(() => c['altura'] = v)),
      _chipRow('Porte físico', portes, c['porte'], (v) => ss(() => c['porte'] = v)),
      _chipRow('Cabelos', cabelos, c['cabelos'], (v) => ss(() => c['cabelos'] = v)),
      _multiChipRow('Marcas', marcas, marcasSel, (v) { if (v == 'Nenhuma aparente') { marcasSel = ['Nenhuma aparente']; } else { marcasSel.remove('Nenhuma aparente'); marcasSel.contains(v) ? marcasSel.remove(v) : marcasSel.add(v); } ss(() => c['marcas'] = marcasSel.join(',')); }),
      _multiChipRow('Vestimenta', vest, vestSel, (v) { vestSel.contains(v) ? vestSel.remove(v) : vestSel.add(v); ss(() => c['vest'] = vestSel.join(',')); }),
    ]);
  }

  Widget _chipRow(String label, List<String> options, String? selected, ValueChanged<String> onSelect) {
    return Padding(padding: const EdgeInsets.only(bottom: 6), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: PCPEColors.mediumGray)), const SizedBox(height: 4), Wrap(spacing: 4, runSpacing: 4, children: options.map((o) => ChoiceChip(label: Text(o, style: TextStyle(fontSize: 11, color: selected == o ? PCPEColors.pureWhite : PCPEColors.darkGray)), selected: selected == o, selectedColor: PCPEColors.primary, backgroundColor: PCPEColors.cardGray, onSelected: (_) => onSelect(o), visualDensity: VisualDensity.compact)).toList())]));
  }

  Widget _multiChipRow(String label, List<String> options, List<String> selected, ValueChanged<String> onToggle) {
    return Padding(padding: const EdgeInsets.only(bottom: 6), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: PCPEColors.mediumGray)), const SizedBox(height: 4), Wrap(spacing: 4, runSpacing: 4, children: options.map((o) => FilterChip(label: Text(o, style: TextStyle(fontSize: 11, color: selected.contains(o) ? PCPEColors.pureWhite : PCPEColors.darkGray)), selected: selected.contains(o), selectedColor: PCPEColors.primary, backgroundColor: PCPEColors.cardGray, onSelected: (_) => onToggle(o), visualDensity: VisualDensity.compact)).toList())]));
  }

  Widget _gpsInfo(String label, String value) => Padding(padding: const EdgeInsets.only(bottom: 2), child: Row(children: [SizedBox(width: 90, child: Text('$label:', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: PCPEColors.success))), Expanded(child: Text(value, style: const TextStyle(fontSize: 10, color: PCPEColors.black)))]));

  void _ocrMock(StateSetter ss, TextEditingController nome, TextEditingController cpf, TextEditingController rg, TextEditingController orgao, DateTime? dataNasc, ValueChanged<DateTime> setData, TextEditingController nat, TextEditingController fil) {
    showDialog(context: context, builder: (ctx) => AlertDialog(
      backgroundColor: PCPEColors.pureWhite, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: Row(children: [const Icon(Icons.document_scanner, color: PCPEColors.primary, size: 22), const SizedBox(width: 8), const Text('OCR Simulado', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700))]),
      content: const Text('Documento detectado. Dados identificados:\n\n• Nome: João da Silva\n• CPF: 123.456.789-00\n• RG: 12.345.678-9\n• Órgão Exp.: SSP-PE\n• Nasc.: 15/03/1990\n• Naturalidade: Recife/PE\n• Filiação: Maria Silva e José Silva\n\nConfira as informações antes de salvar.', style: TextStyle(fontSize: 13, color: PCPEColors.darkGray)),
      actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')), ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: PCPEColors.primary, foregroundColor: PCPEColors.pureWhite, elevation: 0), onPressed: () { Navigator.pop(ctx); ss(() { nome.text = 'João da Silva'; cpf.text = '123.456.789-00'; rg.text = '12.345.678-9'; orgao.text = 'SSP-PE'; nat.text = 'Recife/PE'; fil.text = 'Maria Silva e José Silva'; }); setData(DateTime(1990, 3, 15)); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Dados identificados no documento. Confira as informações antes de salvar.'), backgroundColor: PCPEColors.success, behavior: SnackBarBehavior.floating)); }, child: const Text('Aceitar e preencher'))],
    ));
  }

  Widget _dd(String value, List<String> items, String label, ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(value: items.contains(value) ? value : items.first, decoration: InputDecoration(labelText: label, filled: true, fillColor: PCPEColors.cardGray, border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: PCPEColors.lightGray.withValues(alpha: 0.5))), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: PCPEColors.lightGray.withValues(alpha: 0.5))), focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: PCPEColors.primary, width: 2))), items: items.map((i) => DropdownMenuItem(value: i, child: Text(i))).toList(), onChanged: onChanged);
  }

  Widget _tipoBadge(String tipo) {
    final Color cor; final IconData ic;
    switch (tipo) { case 'Vítima': cor = PCPEColors.error; ic = Icons.person; break; case 'Suspeito': cor = PCPEColors.warning; ic = Icons.person_outline; break; case 'Testemunha': cor = PCPEColors.info; ic = Icons.remove_red_eye; break; case 'Noticiante': cor = PCPEColors.success; ic = Icons.campaign; break; default: cor = PCPEColors.primary; ic = Icons.person; }
    return Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: cor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)), child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(ic, size: 12, color: cor), const SizedBox(width: 4), Text(tipo, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: cor))]));
  }

  void _abrirGaleriaPessoa(int idx) {
    final p = widget.data.pessoas[idx];
    showModalBottomSheet(context: context, isScrollControlled: true, backgroundColor: Colors.transparent, builder: (ctx) => Container(
      height: MediaQuery.of(context).size.height * 0.9, decoration: const BoxDecoration(color: PCPEColors.background, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      child: Column(children: [Container(margin: const EdgeInsets.symmetric(vertical: 12), width: 40, height: 4, decoration: BoxDecoration(color: PCPEColors.lightGray, borderRadius: BorderRadius.circular(2))), Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Row(children: [Expanded(child: Text('${p.tipo}: ${p.nome.isNotEmpty ? p.nome : '(sem nome)'}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: PCPEColors.black))), IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx))])), Expanded(child: SingleChildScrollView(padding: const EdgeInsets.all(16), child: MediaCaptureSection(midias: p.midias, onChanged: () { setState(() {}); widget.onChanged(); }, title: 'Fotografias da Pessoa', subtitle: 'Fotos vinculadas a esta pessoa', gpsTexto: widget.data.gpsCapturado ? '${widget.data.latitude}, ${widget.data.longitude}' : 'GPS não disponível')))])),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      PCPECard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Pessoas Envolvidas', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: PCPEColors.black)),
        const SizedBox(height: 4),
        Text('${widget.data.pessoas.length} pessoa(s) cadastrada(s)', style: const TextStyle(fontSize: 12, color: PCPEColors.mediumGray)),
        const SizedBox(height: 12),
        ...widget.data.pessoas.asMap().entries.map((e) {
          final p = e.value; final i = e.key;
          return Container(
            margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: PCPEColors.cardGray, borderRadius: BorderRadius.circular(8)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                _tipoBadge(p.tipo),
                const SizedBox(width: 8),
                Expanded(child: Text(p.nome.isNotEmpty ? p.nome : p.vitimaNaoIdentificada ? 'Vítima não identificada' : '(sem nome)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: PCPEColors.black, fontStyle: p.nome.isEmpty ? FontStyle.italic : FontStyle.normal))),
              ]),
              const SizedBox(height: 2),
              if (p.cpf.isNotEmpty) Text('CPF: ${p.cpf.substring(0,3)}.***.***-${p.cpf.length > 8 ? p.cpf.substring(p.cpf.length-2) : '**'}', style: const TextStyle(fontSize: 10, color: PCPEColors.mediumGray)),
              if (p.telefone.isNotEmpty) Text('Tel: ${p.telefone}', style: const TextStyle(fontSize: 10, color: PCPEColors.mediumGray)),
              if (p.endereco.isNotEmpty) Text(p.endereco, style: const TextStyle(fontSize: 10, color: PCPEColors.mediumGray), maxLines: 1, overflow: TextOverflow.ellipsis),
              if (p.tipo == 'Vítima') Text('NIC: ${p.nic.isNotEmpty ? p.nic : '—'}', style: const TextStyle(fontSize: 11, color: PCPEColors.mediumGray)),
              const SizedBox(height: 4),
              Row(children: [
                if (p.midias.isNotEmpty) ...[Icon(Icons.photo_camera, size: 12, color: PCPEColors.primary), const SizedBox(width: 2), Text('${p.midias.length} fotos', style: const TextStyle(fontSize: 10, color: PCPEColors.primary)), const SizedBox(width: 10)],
                if (p.documentos.isNotEmpty) ...[Icon(Icons.description, size: 12, color: PCPEColors.info), const SizedBox(width: 2), Text('${p.documentos.length} docs', style: const TextStyle(fontSize: 10, color: PCPEColors.info)), const SizedBox(width: 10)],
                if (p.gpsVitimaLat != null) ...[Icon(Icons.gps_fixed, size: 12, color: PCPEColors.success), const SizedBox(width: 2), const Text('GPS', style: TextStyle(fontSize: 10, color: PCPEColors.success)), const SizedBox(width: 10)],
                if (p.vitimaNaoIdentificada) ...[Icon(Icons.help_outline, size: 12, color: PCPEColors.warning), const SizedBox(width: 2), const Text('Não identificada', style: TextStyle(fontSize: 10, color: PCPEColors.warning)), const SizedBox(width: 10)],
                const Spacer(),
              ]),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                IconButton(icon: const Icon(Icons.photo_camera, size: 18), tooltip: 'Fotos da pessoa', onPressed: () => _abrirGaleriaPessoa(i), color: PCPEColors.primary),
                IconButton(icon: const Icon(Icons.edit, size: 18), tooltip: 'Editar', onPressed: () => _mostrarFormPessoa(pessoa: p, index: i), color: PCPEColors.mediumGray),
                IconButton(icon: const Icon(Icons.delete_outline, size: 18, color: PCPEColors.error), tooltip: 'Excluir', onPressed: () => showDialog(context: context, builder: (ctx) => AlertDialog(title: const Text('Excluir pessoa'), content: const Text('Tem certeza?'), actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')), ElevatedButton(onPressed: () { setState(() => widget.data.pessoas.removeAt(i)); widget.onChanged(); Navigator.pop(ctx); }, style: ElevatedButton.styleFrom(backgroundColor: PCPEColors.error), child: const Text('Excluir'))]))),
              ]),
            ]),
          );
        }),
        PCPEButton(label: 'Adicionar Pessoa', icon: Icons.person_add, fullWidth: true, onPressed: () => _mostrarFormPessoa()),
      ])),
      const SizedBox(height: 24),
    ]));
  }
}