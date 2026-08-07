import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../design_system/design_system.dart';
import '../../shared/widgets/pcpe_button.dart';
import '../../core/services/pdf/ocorrencia_pdf_service.dart';

/// Tela de Visualização Operacional da Ocorrência (F29).
/// Documento institucional somente leitura — base para geração futura do PDF.
class OcorrenciaDetalheScreen extends StatelessWidget {
  final Map<String, dynamic> ocorrencia;
  const OcorrenciaDetalheScreen({super.key, required this.ocorrencia});

  @override
  Widget build(BuildContext context) {
    final status = ocorrencia['status'] as String;

    return Scaffold(
      backgroundColor: PCPEColors.background,
      appBar: _buildAppBar(context, status),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Container(
              decoration: BoxDecoration(
                color: PCPEColors.pureWhite,
                borderRadius: BorderRadius.circular(4),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 8, offset: const Offset(0, 2))],
              ),
              child: Column(children: [
                _buildCabecalho(context, status),
                _buildDivider(),
                _buildSecao('IDENTIFICAÇÃO', Icons.description_outlined, _idFields()),
                _buildDivider(),
                _buildSecao('LOCAL DO CRIME', Icons.location_on_outlined, _localFields()),
                _buildDivider(),
                _buildSecao('PESSOAS', Icons.people_outline, _pessoasWidgets()),
                _buildDivider(),
                _buildSecao('ELEMENTOS RELACIONADOS', Icons.biotech, _elementosWidgets(context)),
                _buildDivider(),
                _buildSecao('NARRATIVA', Icons.edit_note, _narrativaWidgets()),
                _buildDivider(),
                _buildSecao('HISTÓRICO DA OCORRÊNCIA', Icons.timeline, _timelineWidgets(status)),
                if (status == 'Enviada ao SPP') ...[
                  _buildDivider(),
                  _buildSecao('ENVIO AO SPP', Icons.send, _sppWidgets()),
                ],
                _buildFooter(),
              ]),
            ),
          ),
        ),
      ),
    );
  }

  // ═════════════════════════════════════════════════════════════
  // AppBar
  // ═════════════════════════════════════════════════════════════
  PreferredSizeWidget _buildAppBar(BuildContext context, String status) {
    return AppBar(
      backgroundColor: PCPEColors.pureWhite,
      elevation: 0,
      toolbarHeight: 56,
      leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, size: 20), color: PCPEColors.primary, onPressed: () => Navigator.of(context).pop()),
      title: Text(ocorrencia['protocolo'] as String, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: PCPEColors.black)),
      actions: [
        PCPEButton(label: 'Gerar PDF', icon: Icons.picture_as_pdf_outlined, small: true, height: 34, outlined: true, onPressed: () => OcorrenciaPdfService.gerarPdf(ocorrencia)),
        const SizedBox(width: 6),
        PCPEButton(label: 'Imprimir', icon: Icons.print_outlined, small: true, height: 34, outlined: true, onPressed: () => _snack(context, 'Imprimir (simulado)')),
        const SizedBox(width: 8),
      ],
    );
  }

  // ═════════════════════════════════════════════════════════════
  // Cabeçalho
  // ═════════════════════════════════════════════════════════════
  Widget _buildCabecalho(BuildContext context, String status) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(32, 20, 32, 16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: Text(ocorrencia['protocolo'] as String, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: PCPEColors.black, letterSpacing: 0.3))),
          _statusChip(status),
        ]),
        const SizedBox(height: 8),
        Text('${ocorrencia['natureza']} — ${ocorrencia['municipio']} • ${ocorrencia['bairro']}', style: const TextStyle(fontSize: 12, color: PCPEColors.darkGray)),
        const SizedBox(height: 2),
        Text('${ocorrencia['data']} ${ocorrencia['hora']} • Ag. Fabio Fernandes • DHPP - ${ocorrencia['municipio']}', style: const TextStyle(fontSize: 12, color: PCPEColors.mediumGray)),
      ]),
    );
  }

  Widget _statusChip(String s) {
    final Color c; final Color b; final IconData i;
    switch (s) { case 'Rascunho': c=PCPEColors.primary; b=PCPEColors.primarySoft; i=Icons.edit_note; break; case 'A sincronizar': c=PCPEColors.warning; b=PCPEColors.warningLight; i=Icons.sync_problem; break; case 'Concluída': c=PCPEColors.success; b=PCPEColors.successLight; i=Icons.check_circle; break; case 'Enviada ao SPP': c=PCPEColors.primaryDark; b=PCPEColors.cardGray; i=Icons.send; break; default: c=PCPEColors.primary; b=PCPEColors.primarySoft; i=Icons.circle; }
    return Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: b, borderRadius: BorderRadius.circular(20), border: Border.all(color: c.withValues(alpha: 0.4))), child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(i, size: 14, color: c), const SizedBox(width: 4), Text(s, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: c))]));
  }

  // ═════════════════════════════════════════════════════════════
  // Helpers
  // ═════════════════════════════════════════════════════════════
  Widget _buildDivider() => const Divider(height: 1, thickness: 1, color: PCPEColors.surfaceGray);

  Widget _buildSecao(String titulo, IconData icon, List<Widget> children) => Container(
    width: double.infinity, padding: const EdgeInsets.fromLTRB(32, 20, 32, 20),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [Icon(icon, size: 18, color: PCPEColors.primary), const SizedBox(width: 10), Text(titulo, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: PCPEColors.black, letterSpacing: 1.2))]),
      const SizedBox(height: 4), Container(width: 40, height: 2, color: PCPEColors.primary),
      const SizedBox(height: 16), ...children,
    ]),
  );

  Widget _f(String l, String v) => Padding(padding: const EdgeInsets.only(bottom: 6), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [SizedBox(width: 140, child: Text('$l:', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: PCPEColors.darkGray))), Expanded(child: Text(v, style: const TextStyle(fontSize: 13, color: PCPEColors.black)))]));

  Widget _pessoaCard(String nome, {String? nic, String? sexo, String? idade, String? doc, String? obs}) => Container(
    margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(border: Border.all(color: PCPEColors.surfaceGray), borderRadius: BorderRadius.circular(6)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(nome, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: PCPEColors.black)),
      const SizedBox(height: 6),
      Wrap(spacing: 16, runSpacing: 4, children: [
        if (nic != null) _mini('NIC', nic),
        if (sexo != null) _mini('Sexo', sexo),
        if (idade != null) _mini('Idade', idade),
        if (doc != null) _mini('Documento', doc),
        if (obs != null) _mini('Obs', obs),
      ]),
    ]),
  );

  Widget _mini(String l, String v) => Text('$l: $v', style: const TextStyle(fontSize: 11, color: PCPEColors.mediumGray));

  Widget _vazio(String txt) => Text(txt, style: const TextStyle(fontSize: 13, fontStyle: FontStyle.italic, color: PCPEColors.mediumGray));

  Widget _timelineDot(String hora, String evento, {bool last = false}) => Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Column(children: [Container(width: 10, height: 10, decoration: BoxDecoration(color: PCPEColors.primary, shape: BoxShape.circle)), if (!last) Container(width: 2, height: 28, color: PCPEColors.primary.withValues(alpha: 0.3))]),
    const SizedBox(width: 12),
    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(hora, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: PCPEColors.primary)), const SizedBox(height: 2), Text(evento, style: const TextStyle(fontSize: 13, color: PCPEColors.black))]),
  ]);

  void _snack(BuildContext context, String msg) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: PCPEColors.darkGray, behavior: SnackBarBehavior.floating));

  // ═════════════════════════════════════════════════════════════
  // Seções
  // ═════════════════════════════════════════════════════════════

  List<Widget> _idFields() => [
    _f('Protocolo', ocorrencia['protocolo'] as String),
    _f('Natureza', ocorrencia['natureza'] as String),
    _f('Classificação', 'Homicídio'),
    _f('Data', ocorrencia['data'] as String),
    _f('Hora', ocorrencia['hora'] as String),
    _f('Unidade Responsável', 'DHPP - ${ocorrencia['municipio']}'),
    _f('Agente Responsável', 'Ag. Fabio Fernandes'),
    _f('Última atualização', '${ocorrencia['data']} ${ocorrencia['hora']}'),
  ];

  List<Widget> _localFields() => [
    _f('Município', ocorrencia['municipio'] as String),
    _f('Bairro', ocorrencia['bairro'] as String),
    _f('Logradouro', 'Rua Projetada, s/n'),
    _f('Número', '88'),
    _f('Complemento', 'Próximo à praça central'),
    _f('Referência', 'Poste nº 456, em frente à padaria'),
    _f('Latitude', '-8.047620'),
    _f('Longitude', '-34.877030'),
    _f('Tipo de Local', 'Via Pública'),
  ];

  List<Widget> _pessoasWidgets() => [
    _grupoTitulo('VÍTIMAS'),
    _pessoaCard(ocorrencia['vitima'] as String, nic: (ocorrencia['nic'] as String).isNotEmpty ? ocorrencia['nic'] as String : 'Não informado', sexo: 'Masculino', idade: '34 anos', doc: '123.456.789-00'),
    _grupoTitulo('SUSPEITOS'),
    _pessoaCard('Desconhecido', sexo: 'Masculino', idade: 'Aprox. 25-30 anos', obs: 'Indivíduo não identificado. Investigações em andamento.'),
    _grupoTitulo('TESTEMUNHAS'),
    _pessoaCard('Helena Souza', sexo: 'Feminino', doc: '987.654.321-00', obs: 'Residente no imóvel vizinho. Relatou ter ouvido disparos por volta das 14h.'),
  ];

  Widget _grupoTitulo(String t) => Container(width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8), margin: const EdgeInsets.only(bottom: 8), decoration: BoxDecoration(color: PCPEColors.cardGray, borderRadius: BorderRadius.circular(4)), child: Text(t, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: PCPEColors.darkGray, letterSpacing: 1)));

  List<Widget> _elementosWidgets(BuildContext context) => [
    _grupoTitulo('VEÍCULOS'),
    _veiculo('ABC-1234', 'Fiat Uno', 'Branco', 'Abandonado', 'Encontrado com portas abertas.'),
    _veiculo('DEF-5678', 'VW Gol', 'Prata', 'Apreendido', ''),
    const SizedBox(height: 12),
    _grupoTitulo('OBJETOS'),
    _objeto('Arma de Fogo', 'Revólver calibre .38', '1 unidade', 'Próximo ao corpo da vítima.'),
    _objeto('Documento', 'Carteira de identidade', '1 unidade', 'No bolso da vítima.'),
    const SizedBox(height: 12),
    _grupoTitulo('VESTÍGIOS'),
    _vestigio('Biológico', 'Manchas de sangue', 'Calçada em frente ao nº 88', 'Coletado'),
    _vestigio('Balístico', 'Estojo de munição', 'Via pública, a 2m do corpo', 'Coletado'),
    const SizedBox(height: 12),
    _grupoTitulo('FOTOGRAFIAS'),
    const SizedBox(height: 8),
    Wrap(spacing: 8, runSpacing: 8, children: List.generate(6, (_) => GestureDetector(
      onTap: () => _showPhotoDialog(context),
      child: Container(width: 100, height: 75, decoration: BoxDecoration(color: PCPEColors.cardGray, borderRadius: BorderRadius.circular(4), border: Border.all(color: PCPEColors.surfaceGray)), child: const Icon(Icons.image, size: 28, color: PCPEColors.lightGray)),
    ))),
  ];

  Widget _veiculo(String placa, String modelo, String cor, String situacao, String obs) => Container(
    margin: const EdgeInsets.only(bottom: 6), padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(border: Border.all(color: PCPEColors.surfaceGray), borderRadius: BorderRadius.circular(6)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('$modelo — $placa', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
      const SizedBox(height: 2), Text('Cor: $cor  •  Situação: $situacao', style: const TextStyle(fontSize: 11, color: PCPEColors.mediumGray)),
      if (obs.isNotEmpty) Text('Obs: $obs', style: const TextStyle(fontSize: 11, color: PCPEColors.mediumGray)),
    ]),
  );

  Widget _objeto(String t, String desc, String qtd, String local) => Container(
    margin: const EdgeInsets.only(bottom: 6), padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(border: Border.all(color: PCPEColors.surfaceGray), borderRadius: BorderRadius.circular(6)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('$t — $desc', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
      Text('Quantidade: $qtd  •  Local: $local', style: const TextStyle(fontSize: 11, color: PCPEColors.mediumGray)),
    ]),
  );

  Widget _vestigio(String t, String desc, String local, String coleta) => Container(
    margin: const EdgeInsets.only(bottom: 6), padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(border: Border.all(color: PCPEColors.surfaceGray), borderRadius: BorderRadius.circular(6)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('$t — $desc', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
      Text('Local: $local  •  $coleta', style: const TextStyle(fontSize: 11, color: PCPEColors.mediumGray)),
    ]),
  );

  void _showPhotoDialog(BuildContext context) {
    showDialog(context: context, builder: (_) => Dialog(backgroundColor: Colors.transparent, child: Container(
      width: 300, height: 300, decoration: BoxDecoration(color: PCPEColors.cardGray, borderRadius: BorderRadius.circular(12)),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Icon(Icons.image, size: 80, color: PCPEColors.lightGray),
        const SizedBox(height: 12),
        const Text('Visualização ampliada (mock)', style: TextStyle(color: PCPEColors.mediumGray)),
        const SizedBox(height: 16),
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Fechar')),
      ]),
    )));
  }

  List<Widget> _narrativaWidgets() => [
    Container(
      width: double.infinity, padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(border: Border.all(color: PCPEColors.surfaceGray), borderRadius: BorderRadius.circular(6)),
      child: const Text(
        'No dia informado, por volta das 14h30, a equipe de plantão foi acionada via CIODS '
        'para atender ocorrência no endereço supracitado. No local, foi constatado o óbito da '
        'vítima com ferimentos compatíveis com disparo de arma de fogo.\n\n'
        'Foram realizadas as diligências iniciais, coleta de vestígios e acionamento da perícia '
        'criminal. A área foi isolada conforme protocolo operacional padrão. Testemunhas foram '
        'identificadas e prestaram depoimentos preliminares.',
        style: TextStyle(fontSize: 13, height: 1.6, color: PCPEColors.darkGray),
      ),
    ),
    const SizedBox(height: 8),
    _f('Registrado por', 'Ag. Fabio Fernandes'),
    _f('Data do registro', '${ocorrencia['data']} ${ocorrencia['hora']}'),
  ];

  List<Widget> _timelineWidgets(String status) {
    final items = <Widget>[
      _timelineDot('${ocorrencia['hora']}', 'Ocorrência criada'),
      _timelineDot('${ocorrencia['hora']}', 'Local cadastrado'),
      _timelineDot('${ocorrencia['hora']}', 'Pessoas cadastradas'),
      _timelineDot('${ocorrencia['hora']}', 'Narrativa concluída'),
    ];
    final done = status == 'Concluída' || status == 'A sincronizar' || status == 'Enviada ao SPP';
    if (done) {
      items.add(_timelineDot('${ocorrencia['hora']}', 'PDF gerado'));
    }
    if (status == 'Enviada ao SPP') {
      items.add(_timelineDot(ocorrencia['horaEnvioSpp'] ?? '16:42', 'Enviada ao SPP'));
    }
    return items;
  }

  List<Widget> _sppWidgets() => [
    _f('Protocolo SPP', ocorrencia['protocoloSpp'] as String? ?? '—'),
    _f('Data do envio', ocorrencia['dataEnvioSpp'] as String? ?? '—'),
    _f('Hora do envio', ocorrencia['horaEnvioSpp'] as String? ?? '—'),
    _f('Arquivo enviado', '${ocorrencia['protocolo']}.pdf'),
    _f('Situação', 'Enviado com sucesso'),
  ];

  // ═════════════════════════════════════════════════════════════
  // Footer
  // ═════════════════════════════════════════════════════════════
  Widget _buildFooter() => Container(
    width: double.infinity, padding: const EdgeInsets.fromLTRB(32, 20, 32, 32),
    child: Column(children: [
      Container(height: 1, color: PCPEColors.surfaceGray),
      const SizedBox(height: 16),
      const Text('Sistema de Registro de Local de Crime', textAlign: TextAlign.center, style: TextStyle(fontSize: 11, color: PCPEColors.mediumGray)),
      const SizedBox(height: 2),
      const Text('Polícia Civil de Pernambuco', textAlign: TextAlign.center, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: PCPEColors.darkGray)),
      const SizedBox(height: 2),
      const Text('DTI-UNISA — Versão Mock', textAlign: TextAlign.center, style: TextStyle(fontSize: 10, color: PCPEColors.lightGray)),
      const SizedBox(height: 8),
      const Text('Página 1', textAlign: TextAlign.center, style: TextStyle(fontSize: 10, color: PCPEColors.mediumGray)),
    ]),
  );
}