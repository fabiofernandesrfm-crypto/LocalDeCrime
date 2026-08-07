import 'dart:math';
import 'package:flutter/material.dart';
import '../../../shared/models/media_item.dart';

/// Modelo de dados para o Wizard de Registro de Ocorrência.
/// Mantém todo o estado durante o fluxo de cadastro (dados MOCK).
///
/// REESTRUTURAÇÃO F14:
/// - 9 etapas (removida etapa exclusiva "Fotografias / Mídias")
/// - Cada entidade possui sua própria galeria de imagens
/// - Mídias vinculadas diretamente ao item correspondente

// ─────────────────────────────────────────────────────────────────
// Modelos de entidade com galeria de mídias
// ─────────────────────────────────────────────────────────────────

class PessoaEnvolvida {
  String nome;
  String cpf;
  String rg;
  String orgaoExpedidor;
  String naturalidade;
  String filiacao;
  DateTime? dataNascimento;
  String telefone;
  String endereco;
  String tipo; // Vítima, Suspeito, Testemunha, Noticiante
  String nic;
  String observacoes;
  bool vitimaNaoIdentificada;
  Map<String, String> caracteristicas;
  final List<MediaItem> midias;
  final List<MediaItem> documentos;
  final List<String> telefones;
  final List<String> enderecos;
  String? gpsVitimaLat;
  String? gpsVitimaLng;

  PessoaEnvolvida({
    this.nome = '',
    this.cpf = '',
    this.rg = '',
    this.orgaoExpedidor = '',
    this.naturalidade = '',
    this.filiacao = '',
    this.dataNascimento,
    this.telefone = '',
    this.endereco = '',
    this.tipo = 'Vítima',
    this.nic = '',
    this.observacoes = '',
    this.vitimaNaoIdentificada = false,
    Map<String, String>? caracteristicas,
    List<MediaItem>? midias,
    List<MediaItem>? documentos,
    List<String>? telefones,
    List<String>? enderecos,
    this.gpsVitimaLat,
    this.gpsVitimaLng,
  }) : midias = midias ?? [],
       documentos = documentos ?? [],
       telefones = telefones ?? [],
       enderecos = enderecos ?? [],
       caracteristicas = caracteristicas ?? {};
}

class VeiculoEnvolvido {
  String placa;
  String marca;
  String modelo;
  String ano;
  String cor;
  String situacao;
  String responsavel;
  String destinatario;
  String docDestinatario;
  String vinculo;
  String? gpsVeiculoLat;
  String? gpsVeiculoLng;
  String observacoes;
  final List<MediaItem> midias;

  VeiculoEnvolvido({
    this.placa = '',
    this.marca = '',
    this.modelo = '',
    this.ano = '',
    this.cor = '',
    this.situacao = 'Apreendido',
    this.responsavel = '',
    this.destinatario = '',
    this.docDestinatario = '',
    this.vinculo = '',
    this.gpsVeiculoLat,
    this.gpsVeiculoLng,
    this.observacoes = '',
    List<MediaItem>? midias,
  }) : midias = midias ?? [];
}

class ObjetoRelacionado {
  String categoria;
  String descricao;
  int quantidade;
  String situacao;
  String destinacao;
  String responsavel;
  String destinatario;
  String docDestinatario;
  String vinculo;
  String? gpsObjetoLat;
  String? gpsObjetoLng;
  String observacoes;
  final List<MediaItem> midias;

  ObjetoRelacionado({
    this.categoria = '',
    this.descricao = '',
    this.quantidade = 1,
    this.situacao = 'Coletado',
    this.destinacao = '',
    this.responsavel = '',
    this.destinatario = '',
    this.docDestinatario = '',
    this.vinculo = '',
    this.gpsObjetoLat,
    this.gpsObjetoLng,
    this.observacoes = '',
    List<MediaItem>? midias,
  }) : midias = midias ?? [];
}

class VestigioEncontrado {
  String tipo;
  String descricao;
  String localizacao;
  bool coletado;
  String responsavel;
  String observacoes;
  final List<MediaItem> midias;

  VestigioEncontrado({
    this.tipo = '',
    this.descricao = '',
    this.localizacao = '',
    this.coletado = false,
    this.responsavel = '',
    this.observacoes = '',
    List<MediaItem>? midias,
  }) : midias = midias ?? [];
}

// ─────────────────────────────────────────────────────────────────
// Wizard Data principal
// ─────────────────────────────────────────────────────────────────

class OcorrenciaWizardData {
  // ── Etapa 1: Identificação ──────────────────────────────────
  late final String numeroProtocolo;
  String numeroBO = '';
  String numeroInquerito = '';
  String natureza = 'Crime contra a vida';
  String tipoOcorrencia = 'Homicídio Doloso';
  DateTime? dataOcorrencia;
  TimeOfDay? horaOcorrencia;
  String prioridade = 'Alta';
  String status = 'Em andamento';
  String diretoria = '';
  String divisao = '';
  String unidadeResponsavel = '';
  String equipeResponsavel = 'Equipe Delta - Plantão A';

  // ── Etapa 2: Local do Crime ─────────────────────────────────
  String uf = 'PE';
  String municipio = 'Recife';
  String bairro = '';
  String logradouro = '';
  String numero = '';
  String complemento = '';
  String cep = '';
  String pontoReferencia = '';
  String latitude = '';
  String longitude = '';
  bool gpsCapturado = false;
  
  /// Galeria de fotografias do local do crime
  final List<MediaItem> midiasLocal = [];

  // ── Etapa 3: Pessoas Envolvidas ─────────────────────────────
  List<PessoaEnvolvida> pessoas = [];

  // ── Etapa 4: Veículos ───────────────────────────────────────
  List<VeiculoEnvolvido> veiculos = [];

  // ── Etapa 5: Objetos ────────────────────────────────────────
  List<ObjetoRelacionado> objetos = [];

  // ── Etapa 6: Vestígios ──────────────────────────────────────
  List<VestigioEncontrado> vestigios = [];

  // ── Etapa 7: Narrativa ──────────────────────────────────────
  String narrativa = '';
  String observacoesGerais = '';
  String providenciasAdotadas = '';

  // ── Protocolo Final ─────────────────────────────────────────
  String? protocoloFinal;
  DateTime? dataFinalizacao;
  String? horaFinalizacao;

  OcorrenciaWizardData() {
    final now = DateTime.now();
    final random = Random();

    final protocoloNum = 100000 + random.nextInt(900000);
    numeroProtocolo = 'PCPE-${now.year}-${protocoloNum.toString().padLeft(6, '0')}';

    dataOcorrencia = now;
    horaOcorrencia = TimeOfDay.now();
  }

  void gerarProtocoloFinal() {
    final now = DateTime.now();
    final ano = now.year;
    final seq = Random().nextInt(900000) + 100000;
    protocoloFinal = '$ano-${seq.toString().padLeft(6, '0')}';
    dataFinalizacao = now;
    horaFinalizacao =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  }

  void simularCapturaGPS() {
    latitude = '-8.0476${Random().nextInt(999).toString().padLeft(3, '0')}';
    longitude = '-34.8770${Random().nextInt(999).toString().padLeft(3, '0')}';
    gpsCapturado = true;
  }

  /// 7 etapas após reestruturação F17
  int get totalSteps => 7;

  List<String> get stepLabels => [
        'Identificação',
        'Local do Crime',
        'Pessoas',
        'Elementos Relacionados',
        'Narrativa',
        'Revisão',
        'Finalização',
      ];

  List<IconData> get stepIcons => [
        Icons.description_outlined,
        Icons.location_on_outlined,
        Icons.people_outline,
        Icons.search_outlined,
        Icons.edit_note,
        Icons.preview_outlined,
        Icons.check_circle_outline,
      ];

  List<String> get stepOrientations => [
        'Classifique a ocorrência e informe os dados iniciais do registro.',
        'Registre o endereço, as características do local e as fotografias correspondentes.',
        'Cadastre todas as pessoas relacionadas à ocorrência. Para vítimas, informe também o NIC.',
        'Registre os veículos, objetos e vestígios encontrados, incluindo as fotografias correspondentes.',
        'Descreva de forma clara e objetiva os fatos observados. A narrativa poderá ser digitada ou ditada.',
        'Confira as informações registradas e avalie as pendências antes de prosseguir para a conclusão.',
        'Finalize oficialmente a ocorrência e acesse as opções de visualização, impressão, PDF e envio ao SPP.',
      ];

  List<String> get nextButtonLabels => [
        'Continuar para Local do Crime',
        'Continuar para Pessoas',
        'Continuar para Elementos do Local',
        'Continuar para Narrativa',
        'Continuar para Revisão',
        'Prosseguir para Conclusão',
        '', // última etapa não tem botão próximo
      ];

  List<String> get backButtonLabels => [
        '',
        'Voltar para Identificação',
        'Voltar para Pessoas',
        'Voltar para Elementos',
        'Voltar para Narrativa',
        'Voltar para Revisão',
        '',
      ];

  // ─────────────────────────────────────────────────────────────
  // Contagem total de mídias (todas as entidades + local)
  // ─────────────────────────────────────────────────────────────

  int get totalMidias {
    int count = midiasLocal.length;
    for (final p in pessoas) {
      count += p.midias.length;
    }
    for (final v in veiculos) {
      count += v.midias.length;
    }
    for (final o in objetos) {
      count += o.midias.length;
    }
    for (final v in vestigios) {
      count += v.midias.length;
    }
    return count;
  }

  bool get possuiMidias => totalMidias > 0;

  // ─────────────────────────────────────────────────────────────
  // Exportação de mídias organizadas por categoria (PDF futuro)
  // ─────────────────────────────────────────────────────────────

  Map<String, List<MediaItem>> get midiasOrganizadasPorCategoria {
    final Map<String, List<MediaItem>> organizadas = {};

    if (midiasLocal.isNotEmpty) {
      organizadas['Local do Crime'] = List.from(midiasLocal);
    }

    for (final p in pessoas) {
      if (p.midias.isNotEmpty) {
        final key = '${p.tipo}: ${p.nome}';
        organizadas[key] = List.from(p.midias);
      }
    }

    for (final v in veiculos) {
      if (v.midias.isNotEmpty) {
        final key = 'Veículo: ${v.placa}';
        organizadas[key] = List.from(v.midias);
      }
    }

    for (final o in objetos) {
      if (o.midias.isNotEmpty) {
        final key = 'Objeto: ${o.descricao}';
        organizadas[key] = List.from(o.midias);
      }
    }

    for (final v in vestigios) {
      if (v.midias.isNotEmpty) {
        final key = 'Vestígio: ${v.descricao}';
        organizadas[key] = List.from(v.midias);
      }
    }

    return organizadas;
  }

  List<Map<String, dynamic>> exportarMidiasParaPDF() {
    final List<Map<String, dynamic>> lista = [];

    for (final m in midiasLocal) {
      lista.add({
        ...m.toMap(),
        'contexto': 'Local do Crime',
      });
    }

    for (final p in pessoas) {
      for (final m in p.midias) {
        lista.add({
          ...m.toMap(),
          'contexto': '${p.tipo}: ${p.nome}',
        });
      }
    }

    for (final v in veiculos) {
      for (final m in v.midias) {
        lista.add({
          ...m.toMap(),
          'contexto': 'Veículo: ${v.placa}',
        });
      }
    }

    for (final o in objetos) {
      for (final m in o.midias) {
        lista.add({
          ...m.toMap(),
          'contexto': 'Objeto: ${o.descricao}',
        });
      }
    }

    for (final v in vestigios) {
      for (final m in v.midias) {
        lista.add({
          ...m.toMap(),
          'contexto': 'Vestígio: ${v.descricao}',
        });
      }
    }

    return lista;
  }
}