import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../design_system/design_system.dart';
import '../../shared/widgets/pcpe_button.dart';
import '../../shared/widgets/pcpe_input.dart';
import 'ocorrencia_detalhe_screen.dart';
import '../../core/services/pdf/ocorrencia_pdf_service.dart';

/// Central de Ocorrências (F27/F28).
class OcorrenciasScreen extends StatefulWidget {
  final String? statusInicial;
  const OcorrenciasScreen({super.key, this.statusInicial});
  @override
  State<OcorrenciasScreen> createState() => _OcorrenciasScreenState();
}

class _OcorrenciasScreenState extends State<OcorrenciasScreen> {
  final _buscaCtrl = TextEditingController();
  late String _filtroStatus;

  @override
  void initState() {
    super.initState();
    _filtroStatus = widget.statusInicial ?? 'Todas';
  }

  final List<Map<String, dynamic>> _ocorrencias = [
    {'protocolo': 'PCPE-2026-817120', 'nic': 'NIC 0004567', 'natureza': 'Homicídio Doloso Consumado', 'municipio': 'Recife', 'bairro': 'Boa Viagem', 'data': '06/08/2026', 'hora': '14:35', 'vitima': 'João da Silva', 'fotos': 18, 'alteracao': '12 minutos', 'status': 'Concluída'},
    {'protocolo': 'PCPE-2026-817118', 'nic': 'NIC 0004568', 'natureza': 'Feminicídio', 'municipio': 'Olinda', 'bairro': 'Bairro Novo', 'data': '06/08/2026', 'hora': '09:10', 'vitima': 'Maria Oliveira', 'fotos': 22, 'alteracao': '45 minutos', 'status': 'A sincronizar'},
    {'protocolo': 'PCPE-2026-817115', 'nic': '', 'natureza': 'Latrocínio', 'municipio': 'Jaboatão dos Guararapes', 'bairro': 'Piedade', 'data': '05/08/2026', 'hora': '22:40', 'vitima': 'Carlos Eduardo', 'fotos': 15, 'alteracao': '1 hora', 'status': 'Rascunho'},
    {'protocolo': 'PCPE-2026-817112', 'nic': 'NIC 0004570', 'natureza': 'Homicídio Doloso Tentado', 'municipio': 'Paulista', 'bairro': 'Janga', 'data': '05/08/2026', 'hora': '18:15', 'vitima': 'Ana Beatriz', 'fotos': 10, 'alteracao': '3 horas', 'status': 'Concluída'},
    {'protocolo': 'PCPE-2026-817109', 'nic': 'NIC 0004571', 'natureza': 'Morte Violenta a Esclarecer', 'municipio': 'Camaragibe', 'bairro': 'Aldeia', 'data': '05/08/2026', 'hora': '11:00', 'vitima': 'Pedro Lima', 'fotos': 8, 'alteracao': '5 horas', 'status': 'A sincronizar'},
    {'protocolo': 'PCPE-2026-817106', 'nic': '', 'natureza': 'Homicídio Doloso Consumado', 'municipio': 'São Lourenço da Mata', 'bairro': 'Centro', 'data': '04/08/2026', 'hora': '20:30', 'vitima': 'Marcos Vinícius', 'fotos': 25, 'alteracao': '8 horas', 'status': 'Concluída'},
    {'protocolo': 'PCPE-2026-817103', 'nic': 'NIC 0004573', 'natureza': 'Feminicídio', 'municipio': 'Recife', 'bairro': 'Imbiribeira', 'data': '04/08/2026', 'hora': '15:45', 'vitima': 'Juliana Costa', 'fotos': 30, 'alteracao': '8 horas', 'status': 'Rascunho'},
    {'protocolo': 'PCPE-2026-817100', 'nic': 'NIC 0004574', 'natureza': 'Latrocínio', 'municipio': 'Olinda', 'bairro': 'Rio Doce', 'data': '04/08/2026', 'hora': '08:20', 'vitima': 'Roberto Alves', 'fotos': 12, 'alteracao': '1 dia', 'status': 'Concluída'},
    {'protocolo': 'PCPE-2026-817097', 'nic': '', 'natureza': 'Homicídio Doloso Consumado', 'municipio': 'Recife', 'bairro': 'Casa Amarela', 'data': '03/08/2026', 'hora': '23:55', 'vitima': 'Fabio Fernandes', 'fotos': 20, 'alteracao': '1 dia', 'status': 'A sincronizar'},
    {'protocolo': 'PCPE-2026-817094', 'nic': 'NIC 0004576', 'natureza': 'Homicídio Doloso Tentado', 'municipio': 'Paulista', 'bairro': 'Maranguape I', 'data': '03/08/2026', 'hora': '17:10', 'vitima': 'Ana Costa', 'fotos': 14, 'alteracao': '1 dia', 'status': 'Enviada ao SPP', 'dataEnvioSpp': '06/08/2026', 'horaEnvioSpp': '16:42', 'protocoloSpp': 'SPP-2026-004582'},
    {'protocolo': 'PCPE-2026-817091', 'nic': 'NIC 0004577', 'natureza': 'Morte Violenta a Esclarecer', 'municipio': 'Jaboatão dos Guararapes', 'bairro': 'Candeias', 'data': '03/08/2026', 'hora': '12:30', 'vitima': 'João Santos', 'fotos': 6, 'alteracao': '2 dias', 'status': 'Rascunho'},
    {'protocolo': 'PCPE-2026-817088', 'nic': '', 'natureza': 'Homicídio Doloso Consumado', 'municipio': 'Camaragibe', 'bairro': 'Timbi', 'data': '02/08/2026', 'hora': '19:00', 'vitima': 'Maria Silva', 'fotos': 28, 'alteracao': '2 dias', 'status': 'Concluída'},
    {'protocolo': 'PCPE-2026-817085', 'nic': 'NIC 0004579', 'natureza': 'Feminicídio', 'municipio': 'Recife', 'bairro': 'Boa Vista', 'data': '02/08/2026', 'hora': '14:20', 'vitima': 'Carla Mendes', 'fotos': 16, 'alteracao': '2 dias', 'status': 'A sincronizar'},
    {'protocolo': 'PCPE-2026-817082', 'nic': '', 'natureza': 'Latrocínio', 'municipio': 'São Lourenço da Mata', 'bairro': 'Penedo', 'data': '02/08/2026', 'hora': '09:45', 'vitima': 'Rafael Torres', 'fotos': 11, 'alteracao': '3 dias', 'status': 'Rascunho'},
    {'protocolo': 'PCPE-2026-817079', 'nic': 'NIC 0004581', 'natureza': 'Homicídio Doloso Consumado', 'municipio': 'Recife', 'bairro': 'Várzea', 'data': '01/08/2026', 'hora': '21:15', 'vitima': 'Lucas Oliveira', 'fotos': 24, 'alteracao': '3 dias', 'status': 'Enviada ao SPP', 'dataEnvioSpp': '05/08/2026', 'horaEnvioSpp': '10:20', 'protocoloSpp': 'SPP-2026-004581'},
    {'protocolo': 'PCPE-2026-817076', 'nic': 'NIC 0004582', 'natureza': 'Homicídio Doloso Tentado', 'municipio': 'Olinda', 'bairro': 'Jardim Atlântico', 'data': '01/08/2026', 'hora': '16:00', 'vitima': 'Beatriz Santos', 'fotos': 9, 'alteracao': '3 dias', 'status': 'Rascunho'},
  ];

  final _filtros = ['Todas', 'Rascunhos', 'Concluídas', 'A sincronizar', 'Enviadas ao SPP'];

  @override
  void dispose() { _buscaCtrl.dispose(); super.dispose(); }

  List<Map<String, dynamic>> get _filtradas => _ocorrencias.where((o) {
    final s = o['status'] as String;
    switch (_filtroStatus) { case 'Rascunhos': if (s != 'Rascunho') return false; break; case 'Concluídas': if (s != 'Concluída') return false; break; case 'A sincronizar': if (s != 'A sincronizar') return false; break; case 'Enviadas ao SPP': if (s != 'Enviada ao SPP') return false; break; }
    if (_buscaCtrl.text.isNotEmpty) { final q = _buscaCtrl.text.toLowerCase(); final searchable = '${o['protocolo']} ${o['vitima']} ${o['bairro']} ${o['municipio']} ${o['nic']}'.toLowerCase(); if (!searchable.contains(q)) return false; }
    return true;
  }).toList();

  int _countByStatus(String s) => _ocorrencias.where((o) => o['status'] == s).length;

  Color _statusBarColor(String s) { switch (s) { case 'Rascunho': return PCPEColors.primary; case 'A sincronizar': return PCPEColors.warning; case 'Concluída': return PCPEColors.success; case 'Enviada ao SPP': return PCPEColors.primaryDark; default: return PCPEColors.primary; } }

  Widget _chip(String s) {
    final Color c; final Color b; final IconData i;
    switch (s) { case 'Rascunho': c=PCPEColors.primary; b=PCPEColors.primarySoft; i=Icons.edit_note; break; case 'A sincronizar': c=PCPEColors.warning; b=PCPEColors.warningLight; i=Icons.sync_problem; break; case 'Concluída': c=PCPEColors.success; b=PCPEColors.successLight; i=Icons.check_circle; break; case 'Enviada ao SPP': c=PCPEColors.primaryDark; b=PCPEColors.cardGray; i=Icons.send; break; default: c=PCPEColors.primary; b=PCPEColors.primarySoft; i=Icons.circle; }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: b, borderRadius: BorderRadius.circular(20), border: Border.all(color: c.withValues(alpha: 0.4))),
      child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(i, size: 14, color: c), const SizedBox(width: 4), Text(s, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: c))]),
    );
  }

  void _syncOcorrencia(int index) {
    showDialog(context: context, builder: (ctx) => AlertDialog(
      backgroundColor: PCPEColors.pureWhite, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: Row(children: [const Icon(Icons.sync, color: PCPEColors.warning, size: 20), const SizedBox(width: 8), const Expanded(child: Text('Sincronização', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)))]),
      content: const Text('Sincronizar esta ocorrência com o servidor?', style: TextStyle(fontSize: 13, color: PCPEColors.darkGray)),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar', style: TextStyle(color: PCPEColors.darkGray))),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: PCPEColors.primary, foregroundColor: PCPEColors.pureWhite, elevation: 0),
          onPressed: () { Navigator.pop(ctx); setState(() => _ocorrencias[index]['status'] = 'Concluída'); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ocorrência sincronizada com sucesso.'), backgroundColor: PCPEColors.success, behavior: SnackBarBehavior.floating)); },
          child: const Text('Sincronizar'),
        ),
      ],
    ));
  }

  void _sendToSpp(int index) {
    final o = _ocorrencias[index];
    showDialog(context: context, builder: (ctx) => AlertDialog(
      backgroundColor: PCPEColors.pureWhite, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: Row(children: [const Icon(Icons.send, color: PCPEColors.primary, size: 20), const SizedBox(width: 8), const Expanded(child: Text('Envio ao SPP', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)))]),
      content: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('O PDF oficial desta ocorrência será enviado ao SPP.\nDeseja continuar?', style: TextStyle(fontSize: 13, color: PCPEColors.darkGray)),
        const SizedBox(height: 12),
        _infoLine('Protocolo', o['protocolo'] as String),
        _infoLine('Arquivo PDF', '${o['protocolo']}.pdf'),
        _infoLine('Limite máximo', '11 MB'),
        _infoLine('Tamanho simulado', '2.8 MB'),
      ]),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar', style: TextStyle(color: PCPEColors.darkGray))),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: PCPEColors.primary, foregroundColor: PCPEColors.pureWhite, elevation: 0),
          onPressed: () { Navigator.pop(ctx); setState(() { _ocorrencias[index]['status'] = 'Enviada ao SPP'; _ocorrencias[index]['dataEnvioSpp'] = '06/08/2026'; _ocorrencias[index]['horaEnvioSpp'] = '16:42'; _ocorrencias[index]['protocoloSpp'] = 'SPP-2026-004583'; }); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ocorrência enviada ao SPP com sucesso.'), backgroundColor: PCPEColors.success, behavior: SnackBarBehavior.floating)); },
          child: const Text('Enviar ao SPP'),
        ),
      ],
    ));
  }

  Widget _infoLine(String l, String v) => Padding(
    padding: const EdgeInsets.only(bottom: 4),
    child: Row(children: [SizedBox(width: 130, child: Text('$l:', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: PCPEColors.darkGray))), Expanded(child: Text(v, style: const TextStyle(fontSize: 12, color: PCPEColors.black)))]),
  );

  void _gerarPdf(Map<String, dynamic> o) {
    try {
      OcorrenciaPdfService.gerarPdf(o);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível gerar o PDF. Tente novamente.'), backgroundColor: PCPEColors.error, behavior: SnackBarBehavior.floating),
      );
    }
  }

  void _abrirDetalhes(Map<String, dynamic> o) { Navigator.of(context).push(MaterialPageRoute(builder: (_) => OcorrenciaDetalheScreen(ocorrencia: o))); }

  void _onCardTap(Map<String, dynamic> o) { if ((o['status'] as String) == 'Rascunho') { context.go('/nova-ocorrencia'); } else { _abrirDetalhes(o); } }

  void _showFiltrosDialog() {
    showModalBottomSheet(context: context, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))), backgroundColor: PCPEColors.pureWhite, builder: (ctx) => Padding(padding: const EdgeInsets.fromLTRB(24, 20, 24, 32), child: Wrap(spacing: 12, runSpacing: 12, children: [const Text('Filtros Avançados', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)), const SizedBox(width: 999), PCPEInput(hint: 'Município', prefixIcon: Icons.location_city), PCPEInput(hint: 'Bairro', prefixIcon: Icons.map), PCPEInput(hint: 'Natureza', prefixIcon: Icons.gavel), PCPEInput(hint: 'Unidade', prefixIcon: Icons.business), const Text('Filtros mockados', style: TextStyle(fontSize: 11, color: PCPEColors.mediumGray, fontStyle: FontStyle.italic))])));
  }

  Widget _miniIndicator(String l, int v, Color c) => Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: BoxDecoration(color: c.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(8)), child: Row(mainAxisSize: MainAxisSize.min, children: [Text('$v', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: c)), const SizedBox(width: 4), Text(l, style: const TextStyle(fontSize: 11, color: PCPEColors.darkGray))]));

  @override
  Widget build(BuildContext context) {
    final ocorrencias = _filtradas;
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;

    Widget card(Map<String, dynamic> o) {
      final s = o['status'] as String; final bar = _statusBarColor(s); final ehR = s == 'Rascunho'; final ehC = s == 'Concluída'; final ehA = s == 'A sincronizar'; final ehE = s == 'Enviada ao SPP'; final ri = _ocorrencias.indexOf(o);
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
        child: Material(color: PCPEColors.pureWhite, borderRadius: BorderRadius.circular(10), elevation: 0.5,
          child: InkWell(borderRadius: BorderRadius.circular(10), onTap: () => _onCardTap(o),
            child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border(left: BorderSide(color: bar, width: 4))), padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [Expanded(child: Text(o['protocolo'] as String, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: PCPEColors.black))), _chip(s)]),
                const SizedBox(height: 4),
                Text('${(o['nic'] as String).isNotEmpty ? o['nic'] : 'NIC não informado'}  •  ${o['natureza']}', style: const TextStyle(fontSize: 11, color: PCPEColors.darkGray), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 2),
                Row(children: [const Icon(Icons.location_on_outlined, size: 12, color: PCPEColors.mediumGray), const SizedBox(width: 3), Text('${o['municipio']} • ${o['bairro']}', style: const TextStyle(fontSize: 11, color: PCPEColors.darkGray))]),
                const SizedBox(height: 2),
                Row(children: [
                  const Icon(Icons.calendar_today, size: 12, color: PCPEColors.mediumGray), const SizedBox(width: 3), Text('${o['data']} ${o['hora']}', style: const TextStyle(fontSize: 11, color: PCPEColors.darkGray)),
                  const SizedBox(width: 12), const Icon(Icons.person_outline, size: 12, color: PCPEColors.mediumGray), const SizedBox(width: 3),
                  Expanded(child: Text(o['vitima'] as String, style: const TextStyle(fontSize: 11, color: PCPEColors.darkGray), overflow: TextOverflow.ellipsis)),
                  const Icon(Icons.photo_camera_outlined, size: 12, color: PCPEColors.mediumGray), const SizedBox(width: 3), Text('${o['fotos']} fotos', style: const TextStyle(fontSize: 11, color: PCPEColors.mediumGray)),
                ]),
                if (ehE && o['dataEnvioSpp'] != null) ...[
                  const SizedBox(height: 2),
                  Row(children: [const Icon(Icons.send, size: 12, color: PCPEColors.primaryDark), const SizedBox(width: 3), Text('Enviada ao SPP em ${o['dataEnvioSpp']} às ${o['horaEnvioSpp']}  •  Protocolo SPP: ${o['protocoloSpp']}', style: const TextStyle(fontSize: 10, color: PCPEColors.primaryDark))]),
                ],
                const SizedBox(height: 2),
                Row(children: [
                  const Icon(Icons.access_time, size: 12, color: PCPEColors.mediumGray), const SizedBox(width: 3), Text('Atualizada há ${o['alteracao']}', style: const TextStyle(fontSize: 10, color: PCPEColors.lightGray)), const Spacer(),
                  if (ehR) ...[PCPEButton(label: 'Continuar', icon: Icons.edit, small: true, height: 30, onPressed: () => context.go('/nova-ocorrencia')), const SizedBox(width: 6), PCPEButton(label: 'Visualizar', icon: Icons.visibility_outlined, small: true, height: 30, outlined: true, onPressed: () => _abrirDetalhes(o))],
                  if (ehA) ...[PCPEButton(label: 'Visualizar', icon: Icons.visibility_outlined, small: true, height: 30, outlined: true, onPressed: () => _abrirDetalhes(o)), const SizedBox(width: 6), PCPEButton(label: 'Sincronizar', icon: Icons.sync, small: true, height: 30, onPressed: () => _syncOcorrencia(ri))],
                  if (ehC) ...[PCPEButton(label: 'Visualizar', icon: Icons.visibility_outlined, small: true, height: 30, outlined: true, onPressed: () => _abrirDetalhes(o)), const SizedBox(width: 6), PCPEButton(label: 'Gerar PDF', icon: Icons.picture_as_pdf_outlined, small: true, height: 30, outlined: true, onPressed: () => _gerarPdf(o)), const SizedBox(width: 6), PCPEButton(label: 'Enviar ao SPP', icon: Icons.send, small: true, height: 30, onPressed: () => _sendToSpp(ri))],
                  if (ehE) ...[PCPEButton(label: 'Visualizar', icon: Icons.visibility_outlined, small: true, height: 30, outlined: true, onPressed: () => _abrirDetalhes(o)), const SizedBox(width: 6), PCPEButton(label: 'Gerar PDF', icon: Icons.picture_as_pdf_outlined, small: true, height: 30, outlined: true, onPressed: () => _gerarPdf(o)), const SizedBox(width: 6), PCPEButton(label: 'Imprimir', icon: Icons.print_outlined, small: true, height: 30, outlined: true, onPressed: () {})],
                ]),
              ]),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: PCPEColors.background,
      appBar: AppBar(backgroundColor: PCPEColors.pureWhite, elevation: 0, toolbarHeight: 56, title: const Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [Text('Central de Ocorrências', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: PCPEColors.black)), Text('Gerencie os registros de locais de crime.', style: TextStyle(fontSize: 11, color: PCPEColors.mediumGray))]), actions: [if (!isMobile) Padding(padding: const EdgeInsets.only(right: 8), child: PCPEButton(label: 'Nova Ocorrência', icon: Icons.add, small: true, height: 38, onPressed: () => context.go('/nova-ocorrencia'))), if (isMobile) IconButton(icon: const Icon(Icons.add, color: PCPEColors.primary), tooltip: 'Nova Ocorrência', onPressed: () => context.go('/nova-ocorrencia'))]),
      body: Column(children: [
        Container(width: double.infinity, padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10), decoration: BoxDecoration(color: PCPEColors.pureWhite, border: Border(bottom: BorderSide(color: PCPEColors.surfaceGray))), child: Wrap(spacing: 8, runSpacing: 8, alignment: WrapAlignment.spaceAround, children: [_miniIndicator('Registradas', _ocorrencias.length, PCPEColors.primary), _miniIndicator('Rascunhos', _countByStatus('Rascunho'), PCPEColors.primary), _miniIndicator('Concluídas', _countByStatus('Concluída'), PCPEColors.success), _miniIndicator('A sincronizar', _countByStatus('A sincronizar'), PCPEColors.warning), _miniIndicator('Enviadas ao SPP', _countByStatus('Enviada ao SPP'), PCPEColors.primaryDark)])),
        Padding(padding: const EdgeInsets.fromLTRB(16, 12, 16, 6), child: Row(children: [Expanded(child: PCPEInput(hint: 'Pesquisar por protocolo, NIC, vítima ou endereço...', prefixIcon: Icons.search, controller: _buscaCtrl, onChanged: (_) => setState(() {}))), const SizedBox(width: 8), PCPEButton(label: 'Filtros', icon: Icons.tune, outlined: true, small: true, height: 44, onPressed: _showFiltrosDialog)])),
        SizedBox(height: 42, child: ListView.separated(scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 16), itemCount: _filtros.length, separatorBuilder: (_, __) => const SizedBox(width: 6), itemBuilder: (context, index) { final f = _filtros[index]; final sel = f == _filtroStatus; return FilterChip(label: Text(f, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: sel ? PCPEColors.pureWhite : PCPEColors.darkGray)), selected: sel, showCheckmark: false, selectedColor: PCPEColors.primary, backgroundColor: PCPEColors.pureWhite, side: BorderSide(color: sel ? PCPEColors.primary : PCPEColors.surfaceGray), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)), padding: const EdgeInsets.symmetric(horizontal: 10), visualDensity: VisualDensity.compact, onSelected: (_) => setState(() => _filtroStatus = f)); })),
        const SizedBox(height: 6),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Row(children: [const Icon(Icons.folder_outlined, size: 16, color: PCPEColors.mediumGray), const SizedBox(width: 6), Text('${ocorrencias.length} registros encontrados', style: const TextStyle(fontSize: 12, color: PCPEColors.mediumGray))])),
        const SizedBox(height: 6),
        Expanded(child: ocorrencias.isEmpty ? Center(child: Column(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.search_off, size: 48, color: PCPEColors.mediumGray.withValues(alpha: 0.4)), const SizedBox(height: 12), const Text('Nenhuma ocorrência encontrada', style: TextStyle(fontSize: 14, color: PCPEColors.mediumGray))])) : ListView.builder(padding: const EdgeInsets.only(bottom: 16), itemCount: ocorrencias.length, itemBuilder: (context, index) => card(ocorrencias[index]))),
      ]),
    );
  }
}