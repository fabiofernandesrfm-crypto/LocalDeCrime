import 'dart:math';
import 'package:flutter/material.dart';
import '../../../shared/models/media_item.dart';

/// Modelo de dados para o Wizard de Registro de Ocorrência.
/// Mantém todo o estado durante o fluxo de cadastro (dados MOCK).

class PessoaEnvolvida {
  String nome;
  String cpf;
  DateTime? dataNascimento;
  String telefone;
  String endereco;
  String tipo; // Vítima, Suspeito, Testemunha, Comunicante
  String observacoes;

  PessoaEnvolvida({
    this.nome = '',
    this.cpf = '',
    this.dataNascimento,
    this.telefone = '',
    this.endereco = '',
    this.tipo = 'Vítima',
    this.observacoes = '',
  });
}

class VeiculoEnvolvido {
  String placa;
  String marca;
  String modelo;
  String ano;
  String cor;
  String situacao;
  String observacoes;

  VeiculoEnvolvido({
    this.placa = '',
    this.marca = '',
    this.modelo = '',
    this.ano = '',
    this.cor = '',
    this.situacao = 'Apreendido',
    this.observacoes = '',
  });
}

class ObjetoRelacionado {
  String categoria;
  String descricao;
  int quantidade;
  String situacao;
  String observacoes;

  ObjetoRelacionado({
    this.categoria = '',
    this.descricao = '',
    this.quantidade = 1,
    this.situacao = 'Coletado',
    this.observacoes = '',
  });
}

class VestigioEncontrado {
  String tipo;
  String descricao;
  String localizacao;
  bool coletado;
  String responsavel;
  String observacoes;

  VestigioEncontrado({
    this.tipo = '',
    this.descricao = '',
    this.localizacao = '',
    this.coletado = false,
    this.responsavel = '',
    this.observacoes = '',
  });
}

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

  // ── Etapa 3: Pessoas Envolvidas ─────────────────────────────
  List<PessoaEnvolvida> pessoas = [];

  // ── Etapa 4: Veículos ───────────────────────────────────────
  List<VeiculoEnvolvido> veiculos = [];

  // ── Etapa 5: Objetos ────────────────────────────────────────
  List<ObjetoRelacionado> objetos = [];

  // ── Etapa 6: Vestígios ──────────────────────────────────────
  List<VestigioEncontrado> vestigios = [];

  // ── Etapa 7: Fotografias e Mídias ───────────────────────────
  List<MediaItem> midias = [];

  // ── Etapa 8: Narrativa ──────────────────────────────────────
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

  int get totalSteps => 10;

  List<String> get stepLabels => [
        'Identificação',
        'Local do Crime',
        'Pessoas',
        'Veículos',
        'Objetos',
        'Vestígios',
        'Fotografias',
        'Narrativa',
        'Revisão',
        'Finalização',
      ];

  List<IconData> get stepIcons => [
        Icons.description_outlined,
        Icons.location_on_outlined,
        Icons.people_outline,
        Icons.directions_car_outlined,
        Icons.inventory_2_outlined,
        Icons.biotech_outlined,
        Icons.photo_camera_outlined,
        Icons.edit_note,
        Icons.preview_outlined,
        Icons.check_circle_outline,
      ];
}