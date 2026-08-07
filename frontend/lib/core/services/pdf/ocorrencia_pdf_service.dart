import 'dart:math';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

/// Servico responsavel pela montagem do PDF oficial da ocorrencia.
class OcorrenciaPdfService {
  static Future<void> gerarPdf(Map<String, dynamic> ocorrencia) async {
    final pdf = pw.Document(
      title: 'Registro de Local de Crime — ${ocorrencia['protocolo']}',
      author: 'PCPE - DHPP',
    );

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (pw.Context context) => [
          _buildCabecalho(context, ocorrencia),
          pw.SizedBox(height: 20),
          _buildSecaoTitulo('IDENTIFICACAO DA OCORRENCIA'),
          _buildTabelaIdentificacao(ocorrencia),
          pw.SizedBox(height: 16),
          _buildSecaoTitulo('LOCAL DO CRIME'),
          _buildTabelaLocal(ocorrencia),
          pw.SizedBox(height: 16),
          _buildSecaoTitulo('PESSOAS'),
          _buildSecaoPessoas(ocorrencia),
          pw.SizedBox(height: 16),
          _buildSecaoTitulo('ELEMENTOS RELACIONADOS'),
          _buildSecaoElementos(),
          pw.SizedBox(height: 16),
          _buildSecaoTitulo('FOTOGRAFIAS'),
          _buildSecaoFotografias(),
          pw.SizedBox(height: 16),
          _buildSecaoTitulo('NARRATIVA'),
          _buildSecaoNarrativa(),
          pw.SizedBox(height: 16),
          _buildSecaoTitulo('HISTORICO'),
          _buildTimeline(ocorrencia),
          pw.SizedBox(height: 20),
          _buildQrCode(),
          pw.SizedBox(height: 24),
          _buildAssinatura(),
        ],
        footer: (pw.Context context) => _buildRodape(context, ocorrencia),
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  static final _dourado = PdfColor.fromHex('#C8A74E');
  static final _preto = PdfColor.fromHex('#202020');
  static final _cinza = PdfColor.fromHex('#888888');
  static final _cinzaClaro = PdfColor.fromHex('#E0E0E0');

  static pw.TextStyle _tituloStyle() => pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold, color: _preto, letterSpacing: 0.5);
  static pw.TextStyle _normalStyle() => pw.TextStyle(fontSize: 10, color: _preto);
  static pw.TextStyle _smallStyle() => pw.TextStyle(fontSize: 8, color: _cinza);

  static pw.Widget _buildCabecalho(pw.Context context, Map<String, dynamic> o) {
    final now = DateTime.now();
    final dataEmissao = '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}';
    final horaEmissao = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    return pw.Container(
      decoration: pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(color: _dourado, width: 2))),
      padding: const pw.EdgeInsets.only(bottom: 12),
      child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.center, children: [
        pw.Container(width: 50, height: 50, decoration: pw.BoxDecoration(color: _preto, borderRadius: const pw.BorderRadius.all(pw.Radius.circular(10))), child: pw.Center(child: pw.Text('PCPE', style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold, color: _dourado)))),
        pw.SizedBox(height: 10),
        pw.Text('POLICIA CIVIL DE PERNAMBUCO', style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold, color: _preto, letterSpacing: 1.5)),
        pw.SizedBox(height: 2),
        pw.Text('Sistema de Registro de Local de Crime', style: pw.TextStyle(fontSize: 8, color: _cinza)),
        pw.SizedBox(height: 10),
        pw.Text('REGISTRO DE LOCAL DE CRIME', style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold, color: _preto, letterSpacing: 2)),
        pw.SizedBox(height: 8),
        pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
          pw.Text('Protocolo: ${o['protocolo']}', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold, color: _preto)),
          pw.Text('Data: $dataEmissao  Hora: $horaEmissao', style: _smallStyle()),
        ]),
        pw.SizedBox(height: 2),
        pw.Text('Status: ${o['status']}', style: pw.TextStyle(fontSize: 9, color: _dourado, fontWeight: pw.FontWeight.bold)),
      ]),
    );
  }

  static pw.Widget _buildSecaoTitulo(String titulo) => pw.Container(
    margin: const pw.EdgeInsets.only(bottom: 8),
    padding: const pw.EdgeInsets.symmetric(vertical: 4, horizontal: 6),
    decoration: pw.BoxDecoration(color: _cinzaClaro),
    child: pw.Text(titulo, style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold, color: _preto, letterSpacing: 1)),
  );

  static pw.Widget _buildTabelaIdentificacao(Map<String, dynamic> o) => _buildTabela([
    ['Protocolo', o['protocolo'] as String], ['Natureza', o['natureza'] as String], ['Classificacao', 'Homicidio'], ['Data', o['data'] as String], ['Hora', o['hora'] as String], ['Unidade Responsavel', 'DHPP - ${o['municipio']}'], ['Agente Responsavel', 'Ag. Fabio Fernandes'],
  ]);

  static pw.Widget _buildTabelaLocal(Map<String, dynamic> o) => _buildTabela([
    ['Municipio', o['municipio'] as String], ['Bairro', o['bairro'] as String], ['Logradouro', 'Rua Projetada, s/n'], ['Numero', '88'], ['Complemento', 'Proximo a praca central'], ['Referencia', 'Poste nº 456'], ['Latitude', '-8.047620'], ['Longitude', '-34.877030'], ['Tipo do Local', 'Via Publica'],
  ]);

  static pw.Widget _buildTabela(List<List<String>> linhas) => pw.Table(
    border: pw.TableBorder.all(color: _cinzaClaro, width: 0.5),
    columnWidths: const {0: pw.FixedColumnWidth(130), 1: pw.FlexColumnWidth()},
    children: linhas.map((l) => pw.TableRow(children: [
      pw.Container(padding: const pw.EdgeInsets.all(5), color: _cinzaClaro, child: pw.Text(l[0], style: _tituloStyle())),
      pw.Container(padding: const pw.EdgeInsets.all(5), child: pw.Text(l[1], style: _normalStyle())),
    ])).toList(),
  );

  static pw.Widget _buildSecaoPessoas(Map<String, dynamic> o) => pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
    _buildSubTitulo('VITIMAS'),
    _buildTabela([['Nome', o['vitima'] as String], ['NIC', (o['nic'] as String).isNotEmpty ? o['nic'] as String : 'Nao informado'], ['Sexo', 'Masculino'], ['Idade', '34 anos'], ['Documento', '123.456.789-00']]),
    pw.SizedBox(height: 10),
    _buildSubTitulo('SUSPEITOS'),
    _buildTabela([['Nome', 'Desconhecido'], ['Sexo', 'Masculino'], ['Idade', 'Aprox. 25-30 anos'], ['Observacoes', 'Individuo nao identificado.']]),
    pw.SizedBox(height: 10),
    _buildSubTitulo('TESTEMUNHAS'),
    _buildTabela([['Nome', 'Helena Souza'], ['Sexo', 'Feminino'], ['Documento', '987.654.321-00'], ['Depoimento', 'Relatou ter ouvido disparos por volta das 14h.']]),
  ]);

  static pw.Widget _buildSubTitulo(String t) => pw.Container(
    padding: const pw.EdgeInsets.symmetric(vertical: 2), margin: const pw.EdgeInsets.only(bottom: 4),
    child: pw.Text(t, style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold, color: _dourado)),
  );

  static pw.Widget _buildSecaoElementos() => pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
    _buildSubTitulo('VEICULOS'),
    _buildTabelaElemento([['Placa','ABC-1234','Modelo','Fiat Uno','Cor','Branco','Situacao','Abandonado'],['Placa','DEF-5678','Modelo','VW Gol','Cor','Prata','Situacao','Apreendido']]),
    pw.SizedBox(height: 10),
    _buildSubTitulo('OBJETOS'),
    _buildTabelaElemento([['Tipo','Arma de Fogo','Descricao','Revolver cal. .38','Qtd','1','Local','Prox. ao corpo'],['Tipo','Documento','Descricao','Carteira de identidade','Qtd','1','Local','Bolso da vitima']]),
    pw.SizedBox(height: 10),
    _buildSubTitulo('VESTIGIOS'),
    _buildTabelaElemento([['Tipo','Biologico','Descricao','Manchas de sangue','Local','Calcada','Coleta','Coletado'],['Tipo','Balistico','Descricao','Estojo de municao','Local','Via publica','Coleta','Coletado']]),
  ]);

  static pw.Widget _buildTabelaElemento(List<List<String>> linhas) => pw.Table(
    border: pw.TableBorder.all(color: _cinzaClaro, width: 0.5),
    columnWidths: const {0: pw.FixedColumnWidth(40), 1: pw.FlexColumnWidth(), 2: pw.FixedColumnWidth(45), 3: pw.FlexColumnWidth(), 4: pw.FixedColumnWidth(35), 5: pw.FlexColumnWidth(), 6: pw.FixedColumnWidth(45), 7: pw.FlexColumnWidth()},
    children: linhas.map((l) => pw.TableRow(children: [_celulaEscura(l[0]), _celulaClara(l[1]), _celulaEscura(l[2]), _celulaClara(l[3]), _celulaEscura(l[4]), _celulaClara(l[5]), _celulaEscura(l[6]), _celulaClara(l[7])])).toList(),
  );

  static pw.Widget _celulaEscura(String t) => pw.Container(padding: const pw.EdgeInsets.all(4), color: _cinzaClaro, child: pw.Text(t, style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold, color: _preto)));
  static pw.Widget _celulaClara(String t) => pw.Container(padding: const pw.EdgeInsets.all(4), child: pw.Text(t, style: _normalStyle()));

  static pw.Widget _buildSecaoFotografias() => pw.Wrap(spacing: 6, runSpacing: 6, children: List.generate(6, (i) => pw.Container(width: 90, height: 70, decoration: pw.BoxDecoration(color: _cinzaClaro, border: pw.Border.all(color: _cinza)), child: pw.Center(child: pw.Text('[FOTO ${i + 1}]', style: _smallStyle())))));

  static pw.Widget _buildSecaoNarrativa() => pw.Container(
    padding: const pw.EdgeInsets.all(10), decoration: pw.BoxDecoration(border: pw.Border.all(color: _cinzaClaro)),
    child: pw.Text('No dia informado, por volta das 14h30, a equipe de plantao foi acionada via CIODS para atender ocorrencia no endereco supracitado. No local, foi constatado o obito da vitima com ferimentos compativeis com disparo de arma de fogo. Foram realizadas as diligencias iniciais, coleta de vestigios e acionamento da pericia criminal. A area foi isolada conforme protocolo operacional padrao. Testemunhas foram identificadas e prestaram depoimentos preliminares.', style: pw.TextStyle(fontSize: 10, color: _preto, height: 1.5), textAlign: pw.TextAlign.justify),
  );

  static pw.Widget _buildTimeline(Map<String, dynamic> o) {
    final eventos = <List<String>>[
      ['${o['hora']}', 'Ocorrencia criada'], ['${o['hora']}', 'Local cadastrado'], ['${o['hora']}', 'Pessoas cadastradas'], ['${o['hora']}', 'Narrativa concluida'],
    ];
    if (o['status'] != 'Rascunho') eventos.add(['${o['hora']}', 'PDF gerado']);
    if (o['status'] == 'Enviada ao SPP') eventos.add([o['horaEnvioSpp'] ?? '16:42', 'Enviada ao SPP']);
    return pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: eventos.map((e) => pw.Padding(padding: const pw.EdgeInsets.only(bottom: 4), child: pw.Row(children: [pw.Container(width: 8, height: 8, decoration: pw.BoxDecoration(color: _dourado, shape: pw.BoxShape.circle)), pw.SizedBox(width: 8), pw.Text(e[0], style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold, color: _dourado)), pw.SizedBox(width: 12), pw.Text(e[1], style: _normalStyle())]))).toList());
  }

  static pw.Widget _buildQrCode() => pw.Center(child: pw.Column(children: [
    pw.Container(width: 80, height: 80, decoration: pw.BoxDecoration(border: pw.Border.all(color: _preto, width: 2)), child: pw.Center(child: pw.Text('QR', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: _preto)))),
    pw.SizedBox(height: 4), pw.Text('Validacao Institucional', style: _smallStyle()),
  ]));

  static pw.Widget _buildAssinatura() => pw.Container(padding: const pw.EdgeInsets.only(top: 20), child: pw.Column(children: [
    pw.Container(width: 200, height: 1, color: _preto), pw.SizedBox(height: 4),
    pw.Text('Ag. Fabio Fernandes', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold, color: _preto)),
    pw.Text('Agente de Policia Civil', style: _smallStyle()), pw.Text('Matricula: 000.000-0', style: _smallStyle()),
  ]));

  static pw.Widget _buildRodape(pw.Context context, Map<String, dynamic> o) {
    final now = DateTime.now();
    return pw.Container(
      decoration: pw.BoxDecoration(border: pw.Border(top: pw.BorderSide(color: _cinzaClaro))),
      padding: const pw.EdgeInsets.only(top: 8),
      child: pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
        pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
          pw.Text('Documento emitido pelo', style: _smallStyle()),
          pw.Text('Sistema de Registro de Local de Crime — PCPE', style: pw.TextStyle(fontSize: 7, color: _cinza)),
          pw.Text('${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}', style: _smallStyle()),
        ]),
        pw.Text('Pagina ${context.pageNumber} de ${context.pagesCount}', style: _smallStyle()),
      ]),
    );
  }
}