class AtendimentoModel {
  final String id;
  final int numeroRegistro;
  final String status;
  final String tipoLocal;
  final String endereco;
  final String? numero;
  final String? complemento;
  final String bairro;
  final String cidade;
  final String estado;
  final String? cep;
  final double? latitude;
  final double? longitude;
  final String descricao;
  final String? observacoes;
  final DateTime dataOcorrencia;
  final DateTime? dataConclusao;
  final DateTime criadoEm;
  final String usuarioId;

  const AtendimentoModel({
    required this.id,
    required this.numeroRegistro,
    required this.status,
    required this.tipoLocal,
    required this.endereco,
    this.numero,
    this.complemento,
    required this.bairro,
    required this.cidade,
    required this.estado,
    this.cep,
    this.latitude,
    this.longitude,
    required this.descricao,
    this.observacoes,
    required this.dataOcorrencia,
    this.dataConclusao,
    required this.criadoEm,
    required this.usuarioId,
  });

  factory AtendimentoModel.fromJson(Map<String, dynamic> json) {
    return AtendimentoModel(
      id: json['id'] as String,
      numeroRegistro: json['numeroRegistro'] as int,
      status: json['status'] as String,
      tipoLocal: json['tipoLocal'] as String,
      endereco: json['endereco'] as String,
      numero: json['numero'] as String?,
      complemento: json['complemento'] as String?,
      bairro: json['bairro'] as String,
      cidade: json['cidade'] as String,
      estado: json['estado'] as String,
      cep: json['cep'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      descricao: json['descricao'] as String,
      observacoes: json['observacoes'] as String?,
      dataOcorrencia: DateTime.parse(json['dataOcorrencia'] as String),
      dataConclusao: json['dataConclusao'] != null
          ? DateTime.parse(json['dataConclusao'] as String)
          : null,
      criadoEm: DateTime.parse(json['criadoEm'] as String),
      usuarioId: json['usuarioId'] as String,
    );
  }
}