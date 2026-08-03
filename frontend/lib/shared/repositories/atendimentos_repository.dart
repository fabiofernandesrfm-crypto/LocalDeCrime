import '../models/atendimento_model.dart';

// Atendimentos Repository - Mock implementation for Sprint F1
class AtendimentosRepository {
  Future<List<AtendimentoModel>> findAll() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [];
  }

  Future<AtendimentoModel?> findById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return null;
  }
}