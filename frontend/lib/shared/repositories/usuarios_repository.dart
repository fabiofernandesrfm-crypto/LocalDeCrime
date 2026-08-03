import '../models/usuario_model.dart';

// Usuarios Repository - Mock implementation for Sprint F1
class UsuariosRepository {
  Future<List<UsuarioModel>> findAll() async {
    // Mock data - will be replaced with real HTTP calls
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      UsuarioModel(
        id: '1',
        matricula: '123456',
        nome: 'Dr. Carlos Eduardo',
        email: 'carlos.eduardo@pcpe.pe.gov.br',
        cargo: 'Perito Criminal',
        role: 'PERITO',
        ativo: true,
        criadoEm: DateTime.now().subtract(const Duration(days: 365)),
      ),
      UsuarioModel(
        id: '2',
        matricula: '789012',
        nome: 'Dra. Ana Beatriz',
        email: 'ana.beatriz@pcpe.pe.gov.br',
        cargo: 'Médica Legista',
        role: 'PERITO',
        ativo: true,
        criadoEm: DateTime.now().subtract(const Duration(days: 200)),
      ),
      UsuarioModel(
        id: '3',
        matricula: '345678',
        nome: 'Dr. Marcos Vinícius',
        email: 'marcos.vinicius@pcpe.pe.gov.br',
        cargo: 'Perito Criminal',
        role: 'PERITO',
        ativo: false,
        criadoEm: DateTime.now().subtract(const Duration(days: 500)),
      ),
    ];
  }
}