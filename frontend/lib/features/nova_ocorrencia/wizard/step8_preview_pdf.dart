import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../../design_system/design_system.dart';
import '../../../shared/models/media_item.dart';
import 'ocorrencia_wizard_data.dart';

enum ValidationStatus { pronto, alertas, pendente }

class _ItemValidacao { final String mensagem; final bool ok; const _ItemValidacao({required this.mensagem, required this.ok}); }
class _ResultadoValidacao { final ValidationStatus status; final List<_ItemValidacao> obrigatorios; final List<_ItemValidacao> alertas; final List<_ItemValidacao> informativos; const _ResultadoValidacao({required this.status, required this.obrigatorios, required this.alertas, required this.informativos}); }

/// Etapa 6: Revisao / Pre-Visualizacao do PDF (F38).
/// Exibe TODOS os dados coletados nas etapas anteriores.
class Step8PreviewPdf extends StatefulWidget {
  final OcorrenciaWizardData data;
  final VoidCallback? onVoltarEdicao;
  Step8PreviewPdf({super.key, required this.data, this.onVoltarEdicao});
  @override State<Step8PreviewPdf> createState() => _Step8PreviewPdfState();
}

class _Step8PreviewPdfState extends State<Step8PreviewPdf> {
  bool _pendenciasRevisadas = false;
  OcorrenciaWizardData get data => widget.data;

  _ResultadoValidacao _validar() {
    final obrigatorios = <_ItemValidacao>[];
    final alertas = <_ItemValidacao>[];
    final informativos = <_ItemValidacao>[];
    obrigatorios.add(_ItemValidacao(mensagem: 'Protocolo', ok: data.numeroProtocolo.isNotEmpty));
    obrigatorios.add(_ItemValidacao(mensagem: 'Unidade Responsavel', ok: data.unidadeResponsavel.isNotEmpty));
    obrigatorios.add(_ItemValidacao(mensagem: 'Local do Crime', ok: data.logradouro.isNotEmpty));
    obrigatorios.add(_ItemValidacao(mensagem: 'Data da Ocorrencia', ok: data.dataOcorrencia != null));
    obrigatorios.add(_ItemValidacao(mensagem: 'Hora da Ocorrencia', ok: data.horaOcorrencia != null));
    obrigatorios.add(_ItemValidacao(mensagem: 'Pelo menos uma pessoa', ok: data.pessoas.isNotEmpty));
    obrigatorios.add(_ItemValidacao(mensagem: 'Narrativa preenchida', ok: data.narrativa.isNotEmpty));
    for (final p in data.pessoas) { if (p.nome.isEmpty) alertas.add(_ItemValidacao(mensagem: '${p.tipo}: Nome nao informado', ok: false)); if (p.tipo=='Vítima' && p.nic.isEmpty) alertas.add(_ItemValidacao(mensagem: 'Vitima sem NIC', ok: false)); }
    final status = obrigatorios.any((i)=>!i.ok) ? ValidationStatus.pendente : alertas.isNotEmpty ? ValidationStatus.alertas : ValidationStatus.pronto;
    return _ResultadoValidacao(status: status, obrigatorios: obrigatorios, alertas: alertas, informativos: informativos);
  }

  @override Widget build(BuildContext context) {
    final now = DateTime.now();
    final dataEmissao = '${now.day.toString().padLeft(2,'0')}/${now.month.toString().padLeft(2,'0')}/${now.year}';
    final horaEmissao = '${now.hour.toString().padLeft(2,'0')}:${now.minute.toString().padLeft(2,'0')}';
    final validacao = _validar();
    return Column(children: [
      _buildActionBar(context),
      if (!_pendenciasRevisadas) _buildPainelValidacao(),
      Expanded(child: SingleChildScrollView(padding: const EdgeInsets.all(16), child: Center(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 800), child: Container(
        decoration: BoxDecoration(color: PCPEColors.pureWhite, borderRadius: BorderRadius.circular(2), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha:0.08), blurRadius:12, offset:const Offset(0,2))]),
        child: Column(children: [
          _buildCabecalho(dataEmissao, horaEmissao), _div(),
          _sec('IDENTIFICACAO', Icons.description_outlined, _idFields()), _div(),
          _sec('LOCAL DO CRIME', Icons.location_on_outlined, _localFields()), _div(),
          _sec('PESSOAS ENVOLVIDAS', Icons.people_outline, _pessoasFields()), _div(),
          _sec('VEICULOS', Icons.directions_car, _veiculosFields()), _div(),
          _sec('OBJETOS', Icons.inventory_2, _objetosFields()), _div(),
          _sec('VESTIGIOS', Icons.biotech, _vestigiosFields()), _div(),
          _sec('FOTOGRAFIAS', Icons.photo_camera_outlined, _fotosFields()), _div(),
          _sec('NARRATIVA', Icons.edit_note, _narrativaFields()), _div(),
          _buildFooter(),
        ]),
      ))))),
    ]);
  }

  // ── Action Bar ─────────────────────────────────────────────
  Widget _buildActionBar(BuildContext context) {
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;
    return Container(color: PCPEColors.pureWhite, padding: EdgeInsets.symmetric(horizontal: isMobile?8:16, vertical: isMobile?6:10),
      child: SafeArea(bottom: false, child: isMobile? Wrap(spacing:6,runSpacing:6,children: _buttons(context, compact: true)) : Row(children: _buttons(context))));
  }
  List<Widget> _buttons(BuildContext context, {bool compact=false}) {
    final pad = compact? const EdgeInsets.symmetric(horizontal:8,vertical:4) : const EdgeInsets.symmetric(horizontal:12,vertical:6);
    final voltar = _ActionButton(label: compact?'Editar':'Voltar para Editar', icon: Icons.edit_outlined, padding: pad, outlined: true, onPressed: widget.onVoltarEdicao!);
    if (_pendenciasRevisadas) return [if (widget.onVoltarEdicao!=null) voltar, _ActionButton(label: compact?'Concluir':'Concluir Ocorrencia', icon: Icons.check_circle, padding: pad, primary: true, onPressed: () { _mock(context, 'Concluir'); })];
    return [if (widget.onVoltarEdicao!=null) voltar, _ActionButton(label: compact?'Prosseguir':'Prosseguir', icon: Icons.arrow_forward, padding: pad, primary: true, onPressed: () => _handleProsseguir(context))];
  }
  void _handleProsseguir(BuildContext context) { final v = _validar(); if (v.status == ValidationStatus.pendente) { _showConfirmDialog(context); return; } setState(() => _pendenciasRevisadas = true); }
  void _showConfirmDialog(BuildContext context) { showDialog(context: context, builder: (ctx) => AlertDialog(backgroundColor: PCPEColors.pureWhite, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), title: Row(children: [const Icon(Icons.warning_amber_rounded, size:22, color: PCPEColors.warning), const SizedBox(width:10), const Expanded(child: Text('Revisao da Ocorrencia', style: TextStyle(fontSize:16,fontWeight:FontWeight.w700,color:PCPEColors.black)))]), content: const Text('A ocorrencia possui informacoes que poderao ser complementadas posteriormente.\n\nDeseja voltar para editar ou concluir a ocorrencia?', style: TextStyle(fontSize:13,height:1.5,color:PCPEColors.darkGray)), actions: [OutlinedButton.icon(onPressed:()=>Navigator.of(ctx).pop(), icon:const Icon(Icons.edit,size:16), label:const Text('Voltar para Editar', style:TextStyle(fontSize:13)), style:OutlinedButton.styleFrom(foregroundColor:PCPEColors.darkGray,side:const BorderSide(color:PCPEColors.surfaceGray),shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(4)))), const SizedBox(width:8), ElevatedButton.icon(onPressed:(){Navigator.of(ctx).pop();setState(()=>_pendenciasRevisadas=true);}, icon:const Icon(Icons.check,size:16), label:const Text('Prosseguir para Conclusao', style:TextStyle(fontSize:13)), style:ElevatedButton.styleFrom(backgroundColor:PCPEColors.primary,foregroundColor:PCPEColors.pureWhite,shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(4)),elevation:0))])); }
  void _mock(BuildContext context, String a) { ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Acao "$a" mockada.'), backgroundColor: PCPEColors.darkGray, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), margin: const EdgeInsets.all(16))); }

  // ── Validacão ──────────────────────────────────────────────
  Widget _buildPainelValidacao() {
    final v = _validar();
    final Color statusColor;
    final String statusTitulo;
    final String statusSubtitulo;
    if (v.status == ValidationStatus.pronto) {
      statusColor = PCPEColors.success; statusTitulo = 'Pronta para geracao do PDF'; statusSubtitulo = 'Todos os campos obrigatorios foram preenchidos.';
    } else if (v.status == ValidationStatus.alertas) {
      statusColor = PCPEColors.warning; statusTitulo = 'Possui alertas para revisao'; statusSubtitulo = 'Verifique os itens destacados.';
    } else {
      statusColor = PCPEColors.error; statusTitulo = 'Existem pendencias obrigatorias'; statusSubtitulo = 'Preencha os campos obrigatorios.';
    }
    return Container(margin: const EdgeInsets.fromLTRB(12,6,12,4), decoration: BoxDecoration(color: PCPEColors.pureWhite, borderRadius: BorderRadius.circular(4), border: Border.all(color: PCPEColors.surfaceGray)), child: SingleChildScrollView(scrollDirection: Axis.horizontal, child: ConstrainedBox(constraints: const BoxConstraints(maxWidth:800), child: Padding(padding:const EdgeInsets.fromLTRB(20,14,20,14), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [Container(width:36,height:36,decoration:BoxDecoration(color:statusColor.withValues(alpha:0.12),borderRadius:BorderRadius.circular(8)),child:Icon(v.status==ValidationStatus.pronto?Icons.check_circle:Icons.error_outline,size:20,color:statusColor)), const SizedBox(width:12), Expanded(child: Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(statusTitulo,style:TextStyle(fontSize:13,fontWeight:FontWeight.w700,color:PCPEColors.black)), Text(statusSubtitulo,style:TextStyle(fontSize:11,color:PCPEColors.darkGray))]))]),
      const SizedBox(height:14),
      Row(children: [_cnt('Obrigatorios',v.obrigatorios.where((i)=>i.ok).length,v.obrigatorios.length,PCPEColors.success), const SizedBox(width:16), _cnt('Pendencias',v.obrigatorios.where((i)=>!i.ok).length+v.alertas.length,null,PCPEColors.error), const SizedBox(width:16), _cnt('Alertas',v.alertas.length,null,PCPEColors.warning)]),
      const SizedBox(height:14),
      _grupoItens('Dados Obrigatorios',Icons.checklist,v.obrigatorios,corTitulo:PCPEColors.darkGray),
      if(v.alertas.isNotEmpty)...[const SizedBox(height:10), _grupoItens('Alertas para Revisao',Icons.warning_amber_rounded,v.alertas,corTitulo:PCPEColors.warning)],
    ])))));
  }
  Widget _cnt(String l, int v, int? t, Color c) => Row(mainAxisSize:MainAxisSize.min, children:[Container(width:6,height:6,decoration:BoxDecoration(color:c,shape:BoxShape.circle)), const SizedBox(width:6), Text('$l: ',style:const TextStyle(fontSize:11,fontWeight:FontWeight.w600,color:PCPEColors.darkGray)), Text(t!=null?'$v/$t':'$v',style:TextStyle(fontSize:11,fontWeight:FontWeight.w700,color:c))]);
  Widget _grupoItens(String t, IconData i, List<_ItemValidacao> itens, {Color corTitulo=PCPEColors.darkGray}) => Column(crossAxisAlignment:CrossAxisAlignment.start, children:[Row(children:[Icon(i,size:14,color:corTitulo),const SizedBox(width:6),Text(t,style:TextStyle(fontSize:12,fontWeight:FontWeight.w700,color:corTitulo,letterSpacing:0.5))]), const SizedBox(height:6), ...itens.map((item)=>Padding(padding:const EdgeInsets.only(bottom:3), child: Row(crossAxisAlignment:CrossAxisAlignment.start, children:[Icon(item.ok?Icons.check_circle:Icons.cancel,size:14,color:item.ok?PCPEColors.success:PCPEColors.error), const SizedBox(width:6), Expanded(child:Text(item.mensagem,style:TextStyle(fontSize:11,color:item.ok?PCPEColors.darkGray:PCPEColors.error)))])))]);

  // ── Cabeçalho ──────────────────────────────────────────────
  Widget _buildCabecalho(String d, String h) => Container(width:double.infinity,padding:const EdgeInsets.fromLTRB(32,28,32,20),child:Column(children:[
    Container(width:64,height:64,decoration:BoxDecoration(color:const Color(0xFF1B1B1B),borderRadius:BorderRadius.circular(16)),child:const Icon(Icons.shield,size:36,color:PCPEColors.primary)),
    const SizedBox(height:16),
    Text('POLICIA CIVIL DE PERNAMBUCO',textAlign:TextAlign.center,style:PCPETypography.headlineSmall.copyWith(fontWeight:FontWeight.w700,letterSpacing:1.5,color:PCPEColors.black)),
    Text('DHPP — Sistema de Registro de Local de Crime',textAlign:TextAlign.center,style:PCPETypography.bodySmall.copyWith(color:PCPEColors.darkGray)),
    Text('Desenvolvido pela DTI-UNISA',textAlign:TextAlign.center,style:PCPETypography.labelSmall.copyWith(color:PCPEColors.lightGray)),
    const SizedBox(height:16),
    Row(mainAxisAlignment:MainAxisAlignment.center,children:[Text('Emitido em: $d as $h',style:PCPETypography.bodySmall.copyWith(color:PCPEColors.darkGray)),const SizedBox(width:24),Text('Protocolo: ${data.numeroProtocolo}',style:PCPETypography.bodySmall.copyWith(fontWeight:FontWeight.w600,color:PCPEColors.black))]),
  ]));

  // ── Seções ─────────────────────────────────────────────────
  Widget _div() => const Divider(height:1,thickness:1,color:PCPEColors.surfaceGray);

  Widget _sec(String t, IconData ic, List<Widget> c) => Container(width:double.infinity,padding:const EdgeInsets.fromLTRB(32,20,32,20), child:Column(crossAxisAlignment:CrossAxisAlignment.start, children:[
    Text(t,style:PCPETypography.labelLarge.copyWith(fontWeight:FontWeight.w700,color:PCPEColors.black,letterSpacing:1.5)), const SizedBox(height:4), Container(width:40,height:2,color:PCPEColors.primary), const SizedBox(height:16), ...c,
  ]));

  Widget _f(String l, String v) => Padding(padding:const EdgeInsets.only(bottom:6), child:Row(crossAxisAlignment:CrossAxisAlignment.start, children:[SizedBox(width:150,child:Text('$l:',style:const TextStyle(fontSize:12,fontWeight:FontWeight.w600,color:PCPEColors.darkGray))), Expanded(child:Text(v,style:const TextStyle(fontSize:13,color:PCPEColors.black)))]));

  Widget _grupo(String t) => Container(width:double.infinity,padding:const EdgeInsets.symmetric(vertical:4,horizontal:6),margin:const EdgeInsets.only(bottom:8),decoration:BoxDecoration(color:PCPEColors.cardGray,borderRadius:BorderRadius.circular(2)),child:Text(t,style:const TextStyle(fontSize:12,fontWeight:FontWeight.w700,color:PCPEColors.darkGray,letterSpacing:1)));

  Widget _gpsBlock(String? lat, String? lng) { if (lat==null) return const SizedBox.shrink(); return Container(margin:const EdgeInsets.only(top:8),padding:const EdgeInsets.all(8),decoration:BoxDecoration(color:PCPEColors.successLight,borderRadius:BorderRadius.circular(6)),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[_f('Endereco','Av. Conselheiro Aguiar, 4520 - Recife/PE'),_f('Latitude',lat),_f('Longitude',lng??''),_f('Precisao','3 metros'),_f('Data/Hora','07/08/2026')])); }

  // ── Campos ─────────────────────────────────────────────────
  List<Widget> _idFields() => [
    _f('Protocolo', data.numeroProtocolo),
    if (data.numeroBO.isNotEmpty) _f('Numero do BO', data.numeroBO),
    _f('Natureza', data.natureza),
    _f('Tipo da Ocorrencia', data.tipoOcorrencia),
    _f('Data', data.dataOcorrencia!=null?'${data.dataOcorrencia!.day.toString().padLeft(2,'0')}/${data.dataOcorrencia!.month.toString().padLeft(2,'0')}/${data.dataOcorrencia!.year}':'—'),
    _f('Hora', data.horaOcorrencia!=null?'${data.horaOcorrencia!.hour.toString().padLeft(2,'0')}:${data.horaOcorrencia!.minute.toString().padLeft(2,'0')}':'—'),
    _f('Unidade Responsavel', 'DHPP'),
    _f('Responsavel', 'Ag. Fabio Fernandes'),
  ];

  List<Widget> _localFields() => [
    _f('UF', data.uf), _f('Municipio', data.municipio.isNotEmpty?data.municipio:'—'), _f('Bairro', data.bairro.isNotEmpty?data.bairro:'—'),
    _f('Logradouro', data.logradouro.isNotEmpty?data.logradouro:'—'), _f('Numero', data.numero.isNotEmpty?data.numero:'S/N'),
    _f('Complemento', data.complemento.isNotEmpty?data.complemento:'—'), _f('CEP', data.cep.isNotEmpty?data.cep:'—'),
    _f('Referencia', data.pontoReferencia.isNotEmpty?data.pontoReferencia:'—'),
    _f('Coordenadas', data.gpsCapturado?'${data.latitude}, ${data.longitude}':'GPS nao capturado'),
    _f('Fotos do Local', '${data.midiasLocal.length} fotografia(s)'),
  ];

  List<Widget> _pessoasFields() {
    if (data.pessoas.isEmpty) return [_vazio('Nenhuma pessoa cadastrada.')];
    return data.pessoas.map((p) => Container(
      margin: const EdgeInsets.only(bottom:12), padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(border: Border.all(color: PCPEColors.surfaceGray), borderRadius: BorderRadius.circular(4)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [_badge(p.tipo), const SizedBox(width:8), Expanded(child: Text(p.nome.isNotEmpty?p.nome:p.vitimaNaoIdentificada?'Vitima nao identificada':'(sem nome)', style: const TextStyle(fontSize:14,fontWeight:FontWeight.w700,color:PCPEColors.black)))]),
        if (!p.vitimaNaoIdentificada) ...[
          const SizedBox(height:6),
          if (p.cpf.isNotEmpty) _f('CPF', p.cpf),
          if (p.rg.isNotEmpty) _f('RG', p.rg),
          if (p.orgaoExpedidor.isNotEmpty) _f('Orgao Exp.', p.orgaoExpedidor),
          if (p.naturalidade.isNotEmpty) _f('Naturalidade', p.naturalidade),
          if (p.filiacao.isNotEmpty) _f('Filiacao', p.filiacao),
          if (p.dataNascimento!=null) _f('Data Nasc.', '${p.dataNascimento!.day.toString().padLeft(2,'0')}/${p.dataNascimento!.month.toString().padLeft(2,'0')}/${p.dataNascimento!.year}'),
        ],
        if (p.tipo=='Vítima') _f('NIC', p.nic.isNotEmpty?p.nic:'—'),
        if (p.vitimaNaoIdentificada && p.caracteristicas.isNotEmpty) ...[
          const SizedBox(height:6),
          ...p.caracteristicas.entries.where((e)=>e.value.isNotEmpty).map((e)=>_f(e.key, e.value)),
        ],
        if (p.telefones.isNotEmpty || p.telefone.isNotEmpty) ...[
          const SizedBox(height:4), _grupo('Contato'),
          if (p.telefone.isNotEmpty) _f('Telefone', p.telefone),
          ...p.telefones.map((t)=>_f('Tel', t)),
        ],
        if (p.enderecos.isNotEmpty || p.endereco.isNotEmpty) ...[
          const SizedBox(height:4), _grupo('Enderecos'),
          if (p.endereco.isNotEmpty) _f('Endereco', p.endereco),
          ...p.enderecos.map((e)=>_f('End', e)),
        ],
        if (p.gpsVitimaLat!=null) _gpsBlock(p.gpsVitimaLat, p.gpsVitimaLng),
        if (p.documentos.isNotEmpty) ...[const SizedBox(height:4), _f('Documentos', '${p.documentos.length} anexado(s)')],
        if (p.midias.isNotEmpty) ...[const SizedBox(height:4), _f('Fotografias', '${p.midias.length} foto(s) vinculada(s)')],
        if (p.observacoes.isNotEmpty) ...[const SizedBox(height:4), _f('Observacoes', p.observacoes)],
      ]),
    )).toList();
  }

  Widget _badge(String t) {
    final Color c; final IconData i;
    switch (t) { case 'Vítima': c=PCPEColors.error; i=Icons.person; break; case 'Suspeito': c=PCPEColors.warning; i=Icons.person_outline; break; case 'Testemunha': c=PCPEColors.info; i=Icons.remove_red_eye; break; case 'Noticiante': c=PCPEColors.success; i=Icons.campaign; break; default: c=PCPEColors.primary; i=Icons.person; }
    return Container(padding:const EdgeInsets.symmetric(horizontal:8,vertical:3),decoration:BoxDecoration(color:c.withValues(alpha:0.1),borderRadius:BorderRadius.circular(4)),child:Row(mainAxisSize:MainAxisSize.min,children:[Icon(i,size:12,color:c),const SizedBox(width:4),Text(t,style:TextStyle(fontSize:11,fontWeight:FontWeight.w600,color:c))]));
  }

  List<Widget> _veiculosFields() {
    if (data.veiculos.isEmpty) return [_vazio('Nenhum veiculo cadastrado.')];
    return data.veiculos.asMap().entries.map((e) { final v=e.value; return Container(
      margin:const EdgeInsets.only(bottom:10),padding:const EdgeInsets.all(12),
      decoration:BoxDecoration(border:Border.all(color:PCPEColors.surfaceGray),borderRadius:BorderRadius.circular(2)),
      child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
        Row(children:[const Icon(Icons.directions_car,size:16,color:PCPEColors.primary),const SizedBox(width:8),Expanded(child:Text('${e.key+1}. ${v.placa.isNotEmpty?v.placa:'Sem placa'}',style:const TextStyle(fontSize:13,fontWeight:FontWeight.w700)))]),
        const SizedBox(height:6),
        if (v.marca.isNotEmpty || v.modelo.isNotEmpty) _f('Marca/Modelo', '${v.marca} ${v.modelo}'.trim()),
        if (v.ano.isNotEmpty) _f('Ano', v.ano),
        if (v.cor.isNotEmpty) _f('Cor', v.cor),
        _f('Situacao', v.situacao),
        if (v.responsavel.isNotEmpty) _f('Responsavel', v.responsavel),
        if (v.destinatario.isNotEmpty) _f('Entregue a', v.destinatario),
        if (v.docDestinatario.isNotEmpty) _f('Documento', v.docDestinatario),
        if (v.vinculo.isNotEmpty) _f('Vinculo', v.vinculo),
        if (v.gpsVeiculoLat!=null) _gpsBlock(v.gpsVeiculoLat, v.gpsVeiculoLng),
        if (v.midias.isNotEmpty) _f('Fotografias', '${v.midias.length} foto(s)'),
        if (v.observacoes.isNotEmpty) _f('Observacoes', v.observacoes),
      ]),
    );}).toList();
  }

  List<Widget> _objetosFields() {
    if (data.objetos.isEmpty) return [_vazio('Nenhum objeto cadastrado.')];
    return data.objetos.asMap().entries.map((e) { final o=e.value; return Container(
      margin:const EdgeInsets.only(bottom:10),padding:const EdgeInsets.all(12),
      decoration:BoxDecoration(border:Border.all(color:PCPEColors.surfaceGray),borderRadius:BorderRadius.circular(2)),
      child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
        Row(children:[const Icon(Icons.inventory_2,size:16,color:PCPEColors.info),const SizedBox(width:8),Expanded(child:Text('${e.key+1}. ${o.descricao.isNotEmpty?o.descricao:'(sem descricao)'}',style:const TextStyle(fontSize:13,fontWeight:FontWeight.w700)))]),
        const SizedBox(height:6),
        if (o.categoria.isNotEmpty) _f('Categoria', o.categoria),
        _f('Quantidade', '${o.quantidade}'),
        _f('Destinacao', o.destinacao.isNotEmpty?o.destinacao:o.situacao),
        if (o.responsavel.isNotEmpty) _f('Responsavel', o.responsavel),
        if (o.destinatario.isNotEmpty) _f('Restituido a', o.destinatario),
        if (o.docDestinatario.isNotEmpty) _f('Documento', o.docDestinatario),
        if (o.vinculo.isNotEmpty) _f('Vinculo', o.vinculo),
        if (o.gpsObjetoLat!=null) _gpsBlock(o.gpsObjetoLat, o.gpsObjetoLng),
        if (o.midias.isNotEmpty) _f('Fotografias', '${o.midias.length} foto(s)'),
        if (o.observacoes.isNotEmpty) _f('Observacoes', o.observacoes),
      ]),
    );}).toList();
  }

  List<Widget> _vestigiosFields() {
    if (data.vestigios.isEmpty) return [_vazio('Nenhum vestigio cadastrado.')];
    return data.vestigios.asMap().entries.map((e) { final v=e.value; return Container(
      margin:const EdgeInsets.only(bottom:10),padding:const EdgeInsets.all(12),
      decoration:BoxDecoration(border:Border.all(color:PCPEColors.surfaceGray),borderRadius:BorderRadius.circular(2)),
      child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
        Row(children:[Icon(v.coletado?Icons.check_circle:Icons.pending,size:16,color:v.coletado?PCPEColors.success:PCPEColors.warning),const SizedBox(width:8),Expanded(child:Text('${e.key+1}. ${v.descricao.isNotEmpty?v.descricao:'(sem descricao)'}',style:const TextStyle(fontSize:13,fontWeight:FontWeight.w700)))]),
        const SizedBox(height:6),
        if (v.tipo.isNotEmpty) _f('Tipo', v.tipo),
        if (v.localizacao.isNotEmpty) _f('Localizacao', v.localizacao),
        _f('Coletado', v.coletado?'Sim':'Nao'),
        if (v.responsavel.isNotEmpty) _f('Responsavel', v.responsavel),
        if (v.midias.isNotEmpty) _f('Fotografias', '${v.midias.length} foto(s)'),
        if (v.observacoes.isNotEmpty) _f('Observacoes', v.observacoes),
      ]),
    );}).toList();
  }

  List<Widget> _fotosFields() {
    final Map<String,List<MediaItem>> fotos = {};
    if (data.midiasLocal.any((m)=>m.type==MediaType.photo)) fotos['Local do Crime'] = data.midiasLocal.where((m)=>m.type==MediaType.photo).toList();
    int pp=0; for (final p in data.pessoas) { final fp = p.midias.where((m)=>m.type==MediaType.photo).toList(); if (fp.isNotEmpty) { pp++; fotos['${p.tipo} ${pp}: ${p.nome.isNotEmpty?p.nome:'(sem nome)'}'] = fp; } }
    int vp=0; for (final v in data.veiculos) { final fv = v.midias.where((m)=>m.type==MediaType.photo).toList(); if (fv.isNotEmpty) { vp++; fotos['Veiculo ${vp}'] = fv; } }
    int op=0; for (final o in data.objetos) { final fo = o.midias.where((m)=>m.type==MediaType.photo).toList(); if (fo.isNotEmpty) { op++; fotos['Objeto ${op}'] = fo; } }
    int esp=0; for (final v in data.vestigios) { final fv = v.midias.where((m)=>m.type==MediaType.photo).toList(); if (fv.isNotEmpty) { esp++; fotos['Vestigio ${esp}'] = fv; } }
    if (fotos.isEmpty) return [_vazio('Nenhuma fotografia registrada.')];
    return fotos.entries.map((e) => Padding(padding:const EdgeInsets.only(bottom:12), child:Column(crossAxisAlignment:CrossAxisAlignment.start, children:[
      _grupo(e.key.toUpperCase()), const SizedBox(height:8),
      Wrap(spacing:8,runSpacing:8,children:e.value.map((m)=>Container(width:100,height:75,decoration:BoxDecoration(color:m.placeholderColor.withValues(alpha:0.15),border:Border.all(color:PCPEColors.surfaceGray),borderRadius:BorderRadius.circular(2)),child:Column(mainAxisAlignment:MainAxisAlignment.center,children:[Icon(Icons.image,size:24,color:m.placeholderColor.withValues(alpha:0.6)),Padding(padding:const EdgeInsets.symmetric(horizontal:4),child:Text(m.legenda.isNotEmpty?m.legenda:'Foto',maxLines:1,overflow:TextOverflow.ellipsis,style:TextStyle(fontSize:9,color:m.placeholderColor.withValues(alpha:0.8))))]))).toList()),
    ]))).toList();
  }

  List<Widget> _narrativaFields() {
    final items = <Widget>[];
    if (data.narrativa.isNotEmpty) items.add(Container(width:double.infinity,padding:const EdgeInsets.all(12),decoration:BoxDecoration(border:Border.all(color:PCPEColors.surfaceGray),borderRadius:BorderRadius.circular(2)),child:Text(data.narrativa,style:const TextStyle(fontSize:13,height:1.6,color:PCPEColors.black))));
    else items.add(_vazio('Narrativa nao preenchida.'));
    if (data.providenciasAdotadas.isNotEmpty) { items.add(const SizedBox(height:12)); items.add(_grupo('PROVIDENCIAS')); items.add(const SizedBox(height:6)); items.add(Container(width:double.infinity,padding:const EdgeInsets.all(12),decoration:BoxDecoration(border:Border.all(color:PCPEColors.surfaceGray),borderRadius:BorderRadius.circular(2)),child:Text(data.providenciasAdotadas,style:const TextStyle(fontSize:13,color:PCPEColors.darkGray)))); }
    return items;
  }

  Widget _vazio(String t) => Text(t,style:const TextStyle(fontSize:13,fontStyle:FontStyle.italic,color:PCPEColors.mediumGray));

  // ── Footer ─────────────────────────────────────────────────
  Widget _buildFooter() => Container(width:double.infinity,padding:const EdgeInsets.fromLTRB(32,16,32,24),child:Column(children:[
    Container(height:1,color:PCPEColors.surfaceGray), const SizedBox(height:12),
    Text('Documento gerado pelo Sistema de Registro de Atendimento em Local de Crime',textAlign:TextAlign.center,style:PCPETypography.labelSmall.copyWith(color:PCPEColors.lightGray)),
    Text('Policia Civil de Pernambuco',textAlign:TextAlign.center,style:PCPETypography.labelSmall.copyWith(fontWeight:FontWeight.w500,color:PCPEColors.mediumGray)),
    Text('DTI-UNISA — Unidade de Sistemas',textAlign:TextAlign.center,style:PCPETypography.labelSmall.copyWith(color:PCPEColors.lightGray)),
    const SizedBox(height:10), Text('Pagina 1',textAlign:TextAlign.center,style:PCPETypography.labelSmall.copyWith(fontWeight:FontWeight.w600,color:PCPEColors.darkGray)),
  ]));
}

class _ActionButton extends StatelessWidget {
  final String label; final IconData icon; final VoidCallback onPressed; final EdgeInsets padding; final bool outlined; final bool primary;
  const _ActionButton({required this.label, required this.icon, required this.onPressed, this.padding=const EdgeInsets.symmetric(horizontal:12,vertical:6), this.outlined=false, this.primary=false});
  @override Widget build(BuildContext context) {
    if (primary) return Padding(padding:const EdgeInsets.only(left:4), child:ElevatedButton.icon(onPressed:onPressed,icon:Icon(icon,size:16),label:Text(label,style:const TextStyle(fontSize:12)),style:ElevatedButton.styleFrom(backgroundColor:PCPEColors.primary,foregroundColor:PCPEColors.pureWhite,padding:padding,shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(4)),elevation:0)));
    if (outlined) return OutlinedButton.icon(onPressed:onPressed,icon:Icon(icon,size:16),label:Text(label,style:const TextStyle(fontSize:12)),style:OutlinedButton.styleFrom(foregroundColor:PCPEColors.darkGray,side:const BorderSide(color:PCPEColors.surfaceGray),padding:padding,shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(4))));
    return TextButton.icon(onPressed:onPressed,icon:Icon(icon,size:16,color:PCPEColors.darkGray),label:Text(label,style:const TextStyle(fontSize:12,color:PCPEColors.darkGray,fontWeight:FontWeight.w500)),style:TextButton.styleFrom(padding:padding,shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(4))));
  }
}