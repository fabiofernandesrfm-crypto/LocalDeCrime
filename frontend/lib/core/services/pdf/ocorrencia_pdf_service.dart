import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

/// Servico de geracao do PDF oficial da ocorrencia (F39).
/// Espelha fielmente a Visualizacao/Revisao da ocorrencia.
class OcorrenciaPdfService {
  static Future<void> gerarPdf(Map<String, dynamic> o) async {
    final pdf = pw.Document(title: 'Ocorrencia — ${o['protocolo']}', author: 'PCPE - DHPP');

    pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(40),
      build: (ctx) => [
        _cabecalho(ctx, o),
        pw.SizedBox(height: 20),
        _titulo('IDENTIFICACAO DA OCORRENCIA'),
        _tabela(_idDados(o)),
        pw.SizedBox(height: 16),
        _titulo('LOCAL DO CRIME'),
        _tabela(_localDados(o)),
        pw.SizedBox(height: 16),
        _titulo('PESSOAS ENVOLVIDAS'),
        ..._pessoasBlocos(o),
        pw.SizedBox(height: 16),
        _titulo('VEICULOS'),
        ..._veiculosBlocos(o),
        pw.SizedBox(height: 16),
        _titulo('OBJETOS'),
        ..._objetosBlocos(o),
        pw.SizedBox(height: 16),
        _titulo('VESTIGIOS'),
        ..._vestigiosBlocos(o),
        pw.SizedBox(height: 16),
        _titulo('FOTOGRAFIAS'),
        ..._fotosBlocos(o),
        pw.SizedBox(height: 16),
        _titulo('NARRATIVA'),
        _narrativa(o),
        pw.SizedBox(height: 20),
        _assinatura(),
      ],
      footer: (ctx) => _rodape(ctx),
    ));

    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }

  // Cores
  static final _dourado = PdfColor.fromHex('#C8A74E');
  static final _preto = PdfColor.fromHex('#202020');
  static final _cinza = PdfColor.fromHex('#888888');
  static final _cinzaClaro = PdfColor.fromHex('#E0E0E0');

  static pw.TextStyle _tit() => pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold, color: _preto);
  static pw.TextStyle _txt() => pw.TextStyle(fontSize: 10, color: _preto);
  static pw.TextStyle _sm() => pw.TextStyle(fontSize: 8, color: _cinza);

  // ── Cabeçalho ──────────────────────────────────────────────
  static pw.Widget _cabecalho(pw.Context ctx, Map<String, dynamic> o) {
    final now = DateTime.now();
    final d = '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}';
    final h = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    return pw.Container(
      decoration: pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(color: _dourado, width: 2))),
      padding: const pw.EdgeInsets.only(bottom: 12),
      child: pw.Column(children: [
        pw.Container(width: 50, height: 50, decoration: pw.BoxDecoration(color: _preto, borderRadius: const pw.BorderRadius.all(pw.Radius.circular(10))), child: pw.Center(child: pw.Text('PCPE', style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold, color: _dourado)))),
        pw.SizedBox(height: 10),
        pw.Text('POLICIA CIVIL DE PERNAMBUCO', style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold, color: _preto, letterSpacing: 1.5)),
        pw.Text('DHPP — Sistema de Registro de Local de Crime', style: _sm()),
        pw.SizedBox(height: 8),
        pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
          pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
            pw.Text('Protocolo: ${o['protocolo']}', style: _tit()),
            pw.Text('Emitido em: $d as $h', style: _sm()),
          ]),
          pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.end, children: [
            pw.Text('Unidade: DHPP', style: _txt()),
            pw.Text('Responsavel: Ag. Fabio Fernandes', style: _txt()),
          ]),
        ]),
      ]),
    );
  }

  // ── Título ─────────────────────────────────────────────────
  static pw.Widget _titulo(String t) => pw.Container(
    margin: const pw.EdgeInsets.only(bottom: 8),
    padding: const pw.EdgeInsets.symmetric(vertical: 4, horizontal: 6),
    decoration: pw.BoxDecoration(color: _cinzaClaro),
    child: pw.Text(t, style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold, color: _preto, letterSpacing: 1)),
  );

  // ── Tabela simples ─────────────────────────────────────────
  static pw.Widget _tabela(List<List<String>> linhas) => pw.Table(
    border: pw.TableBorder.all(color: _cinzaClaro, width: 0.5),
    columnWidths: const {0: pw.FixedColumnWidth(130), 1: pw.FlexColumnWidth()},
    children: linhas.where((l) => l[1].isNotEmpty).map((l) => pw.TableRow(children: [
      pw.Container(padding: const pw.EdgeInsets.all(5), color: _cinzaClaro, child: pw.Text(l[0], style: _tit())),
      pw.Container(padding: const pw.EdgeInsets.all(5), child: pw.Text(l[1], style: _txt())),
    ])).toList(),
  );

  static pw.Widget _sub(String t) => pw.Container(
    padding: const pw.EdgeInsets.symmetric(vertical: 2), margin: const pw.EdgeInsets.only(bottom: 4, top: 8),
    child: pw.Text(t, style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold, color: _dourado)),
  );

  static pw.Widget _gpsBlock(String? lat, String? lng) {
    if (lat == null) return pw.SizedBox.shrink();
    return pw.Container(
      padding: const pw.EdgeInsets.all(6),
      decoration: pw.BoxDecoration(color: _cinzaClaro, borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4))),
      child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
        pw.Text('LOCALIZACAO GPS', style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold, color: _preto)),
        _linha('Endereco', 'Av. Conselheiro Aguiar, 4520 - Recife/PE'),
        _linha('Latitude', lat),
        _linha('Longitude', lng ?? ''),
        _linha('Precisao', '3 metros'),
      ]),
    );
  }

  static pw.Widget _linha(String l, String v) => pw.Padding(padding: const pw.EdgeInsets.only(bottom: 2), child: pw.Row(children: [pw.SizedBox(width: 100, child: pw.Text('$l:', style: _tit())), pw.Expanded(child: pw.Text(v, style: _txt()))]));

  // ── Dados ──────────────────────────────────────────────────
  static List<List<String>> _idDados(Map<String, dynamic> o) => [
    ['Protocolo', o['protocolo'] as String],
    ['NIC', o['nic'] as String? ?? ''],
    ['Natureza', o['natureza'] as String],
    ['Tipo', o['tipoOcorrencia'] as String? ?? ''],
    ['Data', o['data'] as String],
    ['Hora', o['hora'] as String],
    ['Unidade', 'DHPP'],
    ['Responsavel', 'Ag. Fabio Fernandes'],
  ];

  static List<List<String>> _localDados(Map<String, dynamic> o) => [
    ['Municipio', o['municipio'] as String],
    ['Bairro', o['bairro'] as String],
    ['Logradouro', 'Rua Projetada, s/n'],
    ['Numero', '88'],
    ['Complemento', 'Proximo a praca central'],
    ['Referencia', 'Poste nº 456'],
    ['Latitude', '-8.047620'],
    ['Longitude', '-34.877030'],
    ['Precisao', '3 metros'],
  ];

  // ── Pessoas ────────────────────────────────────────────────
  static List<pw.Widget> _pessoasBlocos(Map<String, dynamic> o) {
    final pessoas = o['pessoas'] as List<Map<String, dynamic>>? ?? [];
    if (pessoas.isEmpty) return [pw.Text('Nenhuma pessoa cadastrada.', style: pw.TextStyle(fontSize: 10, fontStyle: pw.FontStyle.italic, color: _cinza))];
    return pessoas.map((p) {
      final items = <List<String>>[];
      if (p['vitimaNaoIdentificada'] == true) {
        items.add(['VITIMA NAO IDENTIFICADA', '']);
        final carac = p['caracteristicas'] as Map<String, dynamic>? ?? {};
        for (final e in carac.entries) { if (e.value.toString().isNotEmpty) items.add([e.key, e.value.toString()]); }
      } else {
        items.addAll([['Nome', p['nome'] as String? ?? ''], ['CPF', p['cpf'] as String? ?? ''], ['RG', p['rg'] as String? ?? ''], ['Orgao Exp.', p['orgaoExpedidor'] as String? ?? ''], ['Naturalidade', p['naturalidade'] as String? ?? ''], ['Filiacao', p['filiacao'] as String? ?? '']]);
        if (p['dataNascimento'] != null) items.add(['Data Nasc.', p['dataNascimento']]);
      }
      if (p['tipo'] == 'Vítima') items.add(['NIC', p['nic'] as String? ?? '']);
      final tels = (p['telefones'] as List<dynamic>?)?.cast<String>() ?? [];
      if (p['telefone']?.toString().isNotEmpty == true || tels.isNotEmpty) {
        if (p['telefone']?.toString().isNotEmpty == true) items.add(['Telefone', p['telefone'] as String]);
        for (final t in tels) { items.add(['Tel', t]); }
      }
      final ends = (p['enderecos'] as List<dynamic>?)?.cast<String>() ?? [];
      if (p['endereco']?.toString().isNotEmpty == true || ends.isNotEmpty) {
        if (p['endereco']?.toString().isNotEmpty == true) items.add(['Endereco', p['endereco'] as String]);
        for (final e in ends) { items.add(['End', e]); }
      }
      if (p['observacoes']?.toString().isNotEmpty == true) items.add(['Observacoes', p['observacoes'] as String]);
      return pw.Column(children: [
        _sub('${p['tipo']}'.toUpperCase()),
        _tabela(items),
        if (p['gpsVitimaLat'] != null) _gpsBlock(p['gpsVitimaLat'] as String?, p['gpsVitimaLng'] as String?),
        if ((p['midias'] as List<dynamic>?)?.isNotEmpty == true) _fotosMini('${p['tipo']}: ${p['nome']}', p['midias'] as List<Map<String, dynamic>>),
      ]);
    }).toList();
  }

  // ── Veículos ───────────────────────────────────────────────
  static List<pw.Widget> _veiculosBlocos(Map<String, dynamic> o) {
    final veiculos = o['veiculos'] as List<Map<String, dynamic>>? ?? [];
    if (veiculos.isEmpty) return [pw.Text('Nenhum veiculo cadastrado.', style: pw.TextStyle(fontSize: 10, fontStyle: pw.FontStyle.italic, color: _cinza))];
    return veiculos.map((v) => pw.Column(children: [
      _sub('VEICULO ${v['placa'] ?? 'Sem placa'}'),
      _tabela([
        ['Placa', v['placa'] as String? ?? ''],
        ['Marca/Modelo', '${v['marca'] ?? ''} ${v['modelo'] ?? ''}'.trim()],
        ['Ano', v['ano'] as String? ?? ''],
        ['Cor', v['cor'] as String? ?? ''],
        ['Situacao', v['situacao'] as String? ?? ''],
        ['Responsavel', v['responsavel'] as String? ?? ''],
        ['Entregue a', v['destinatario'] as String? ?? ''],
        ['Documento', v['docDestinatario'] as String? ?? ''],
        ['Vinculo', v['vinculo'] as String? ?? ''],
        ['Observacoes', v['observacoes'] as String? ?? ''],
      ]),
      if (v['gpsVeiculoLat'] != null) _gpsBlock(v['gpsVeiculoLat'] as String?, v['gpsVeiculoLng'] as String?),
      if ((v['midias'] as List<dynamic>?)?.isNotEmpty == true) _fotosMini('Veiculo ${v['placa']}', v['midias'] as List<Map<String, dynamic>>),
    ])).toList();
  }

  // ── Objetos ────────────────────────────────────────────────
  static List<pw.Widget> _objetosBlocos(Map<String, dynamic> o) {
    final objetos = o['objetos'] as List<Map<String, dynamic>>? ?? [];
    if (objetos.isEmpty) return [pw.Text('Nenhum objeto cadastrado.', style: pw.TextStyle(fontSize: 10, fontStyle: pw.FontStyle.italic, color: _cinza))];
    return objetos.map((obj) => pw.Column(children: [
      _sub('OBJETO: ${obj['descricao'] ?? '(sem descricao)'}'),
      _tabela([
        ['Categoria', obj['categoria'] as String? ?? ''],
        ['Quantidade', '${obj['quantidade'] ?? 1}'],
        ['Destinacao', obj['destinacao'] as String? ?? obj['situacao'] as String? ?? ''],
        ['Responsavel', obj['responsavel'] as String? ?? ''],
        ['Restituido a', obj['destinatario'] as String? ?? ''],
        ['Documento', obj['docDestinatario'] as String? ?? ''],
        ['Vinculo', obj['vinculo'] as String? ?? ''],
        ['Observacoes', obj['observacoes'] as String? ?? ''],
      ]),
      if (obj['gpsObjetoLat'] != null) _gpsBlock(obj['gpsObjetoLat'] as String?, obj['gpsObjetoLng'] as String?),
      if ((obj['midias'] as List<dynamic>?)?.isNotEmpty == true) _fotosMini('Objeto ${obj['descricao']}', obj['midias'] as List<Map<String, dynamic>>),
    ])).toList();
  }

  // ── Vestígios ──────────────────────────────────────────────
  static List<pw.Widget> _vestigiosBlocos(Map<String, dynamic> o) {
    final vestigios = o['vestigios'] as List<Map<String, dynamic>>? ?? [];
    if (vestigios.isEmpty) return [pw.Text('Nenhum vestigio cadastrado.', style: pw.TextStyle(fontSize: 10, fontStyle: pw.FontStyle.italic, color: _cinza))];
    return vestigios.map((v) => pw.Column(children: [
      _sub('VESTIGIO: ${v['descricao'] ?? '(sem descricao)'}'),
      _tabela([
        ['Tipo', v['tipo'] as String? ?? ''],
        ['Localizacao', v['localizacao'] as String? ?? ''],
        ['Coletado', v['coletado'] == true ? 'Sim' : 'Nao'],
        ['Responsavel', v['responsavel'] as String? ?? ''],
        ['Observacoes', v['observacoes'] as String? ?? ''],
      ]),
      if ((v['midias'] as List<dynamic>?)?.isNotEmpty == true) _fotosMini('Vestigio ${v['descricao']}', v['midias'] as List<Map<String, dynamic>>),
    ])).toList();
  }

  // ── Fotos ──────────────────────────────────────────────────
  static List<pw.Widget> _fotosBlocos(Map<String, dynamic> o) {
    final Map<String, List<Map<String, dynamic>>> fotos = {};
    final local = (o['midiasLocal'] as List<dynamic>?)?.cast<Map<String, dynamic>>() ?? [];
    if (local.any((m) => m['type'] == 'photo')) fotos['Local do Crime'] = local.where((m) => m['type'] == 'photo').toList();
    final pessoas = o['pessoas'] as List<Map<String, dynamic>>? ?? [];
    for (final p in pessoas) {
      final fp = (p['midias'] as List<dynamic>?)?.cast<Map<String, dynamic>>().where((m) => m['type'] == 'photo').toList() ?? [];
      if (fp.isNotEmpty) fotos['${p['tipo']}: ${p['nome'] ?? '(sem nome)'}'] = fp;
    }
    final veiculos = o['veiculos'] as List<Map<String, dynamic>>? ?? [];
    for (final v in veiculos) {
      final fv = (v['midias'] as List<dynamic>?)?.cast<Map<String, dynamic>>().where((m) => m['type'] == 'photo').toList() ?? [];
      if (fv.isNotEmpty) fotos['Veiculo ${v['placa']}'] = fv;
    }
    final objetos = o['objetos'] as List<Map<String, dynamic>>? ?? [];
    for (final obj in objetos) {
      final fo = (obj['midias'] as List<dynamic>?)?.cast<Map<String, dynamic>>().where((m) => m['type'] == 'photo').toList() ?? [];
      if (fo.isNotEmpty) fotos['Objeto ${obj['descricao']}'] = fo;
    }
    final vestigios = o['vestigios'] as List<Map<String, dynamic>>? ?? [];
    for (final v in vestigios) {
      final fv = (v['midias'] as List<dynamic>?)?.cast<Map<String, dynamic>>().where((m) => m['type'] == 'photo').toList() ?? [];
      if (fv.isNotEmpty) fotos['Vestigio ${v['descricao']}'] = fv;
    }
    if (fotos.isEmpty) return [pw.Text('Nenhuma fotografia registrada.', style: pw.TextStyle(fontSize: 10, fontStyle: pw.FontStyle.italic, color: _cinza))];
    return fotos.entries.map((e) => pw.Column(children: [
      _sub(e.key.toUpperCase()),
      pw.Wrap(spacing: 6, runSpacing: 6, children: e.value.take(6).map((_) => pw.Container(width: 80, height: 60, decoration: pw.BoxDecoration(color: _cinzaClaro, border: pw.Border.all(color: _cinza)), child: pw.Center(child: pw.Text('[FOTO]', style: _sm())))).toList()),
    ])).toList();
  }

  static pw.Widget _fotosMini(String label, List<Map<String, dynamic>> midias) {
    if (midias.isEmpty) return pw.SizedBox.shrink();
    return pw.Column(children: [
      _sub('FOTOGRAFIAS'),
      pw.Wrap(spacing: 6, runSpacing: 6, children: midias.take(4).map((_) => pw.Container(width: 80, height: 60, decoration: pw.BoxDecoration(color: _cinzaClaro, border: pw.Border.all(color: _cinza)), child: pw.Center(child: pw.Text('[FOTO]', style: _sm())))).toList()),
    ]);
  }

  // ── Narrativa ──────────────────────────────────────────────
  static pw.Widget _narrativa(Map<String, dynamic> o) {
    final narrativa = o['narrativa'] as String? ?? '';
    final providencias = o['providenciasAdotadas'] as String? ?? '';
    return pw.Column(children: [
      if (narrativa.isNotEmpty) pw.Container(padding: const pw.EdgeInsets.all(10), decoration: pw.BoxDecoration(border: pw.Border.all(color: _cinzaClaro)), child: pw.Text(narrativa, style: pw.TextStyle(fontSize: 10, color: _preto, height: 1.5), textAlign: pw.TextAlign.justify))
      else pw.Text('Narrativa nao preenchida.', style: pw.TextStyle(fontSize: 10, fontStyle: pw.FontStyle.italic, color: _cinza)),
      if (providencias.isNotEmpty) ...[pw.SizedBox(height: 12), _sub('PROVIDENCIAS'), pw.Container(padding: const pw.EdgeInsets.all(10), decoration: pw.BoxDecoration(border: pw.Border.all(color: _cinzaClaro)), child: pw.Text(providencias, style: pw.TextStyle(fontSize: 10, color: _preto)))],
    ]);
  }

  // ── Assinatura ─────────────────────────────────────────────
  static pw.Widget _assinatura() {
    return pw.Container(
      padding: const pw.EdgeInsets.only(top: 30),
      child: pw.Column(
        children: [
          pw.Container(width: 200, height: 1, color: _preto),
          pw.SizedBox(height: 4),
          pw.Text('Ag. Fabio Fernandes', style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold, color: _preto)),
          pw.Text('Agente de Policia Civil — DHPP', style: _sm()),
          pw.Text('Matricula: 000.000-0', style: _sm()),
          pw.SizedBox(height: 8),
          pw.Text('Documento gerado pelo Sistema de Registro de Local de Crime — PCPE', style: _sm()),
        ],
      ),
    );
  }

  // ── Rodapé ─────────────────────────────────────────────────
  static pw.Widget _rodape(pw.Context ctx) => pw.Container(
    decoration: pw.BoxDecoration(border: pw.Border(top: pw.BorderSide(color: PdfColor.fromHex('#E0E0E0')))),
    padding: const pw.EdgeInsets.only(top: 8),
    child: pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
      pw.Text('Sistema de Registro de Local de Crime — PCPE', style: _sm()),
      pw.Text('Pagina ${ctx.pageNumber} de ${ctx.pagesCount}', style: _sm()),
    ]),
  );
}