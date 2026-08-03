class UsuarioModel {
  final String id;
  final String matricula;
  final String nome;
  final String email;
  final String? cargo;
  final String role;
  final bool ativo;
  final DateTime criadoEm;

  const UsuarioModel({
    required this.id,
    required this.matricula,
    required this.nome,
    required this.email,
    this.cargo,
    required this.role,
    required this.ativo,
    required this.criadoEm,
  });

  factory UsuarioModel.fromJson(Map<String, dynamic> json) {
    return UsuarioModel(
      id: json['id'] as String,
      matricula: json['matricula'] as String,
      nome: json['nome'] as String,
      email: json['email'] as String,
      cargo: json['cargo'] as String?,
      role: json['role'] as String,
      ativo: json['ativo'] as bool,
      criadoEm: DateTime.parse(json['criadoEm'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'matricula': matricula,
      'nome': nome,
      'email': email,
      'cargo': cargo,
      'role': role,
      'ativo': ativo,
      'criadoEm': criadoEm.toIso8601String(),
    };
  }
}