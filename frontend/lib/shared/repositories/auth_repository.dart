// Auth Repository - Mock implementation for Sprint F1
class AuthRepository {
  String? _token;

  Future<Map<String, dynamic>> login(String matricula, String senha) async {
    // Mock login - will be replaced with real HTTP calls
    await Future.delayed(const Duration(seconds: 1));
    return {
      'accessToken': 'mock_token_abc123',
      'user': {
        'id': '1',
        'matricula': matricula,
        'nome': 'Dr. Carlos Eduardo',
        'email': 'carlos.eduardo@pcpe.pe.gov.br',
        'cargo': 'Perito Criminal',
        'role': 'PERITO',
        'ativo': true,
        'criadoEm': DateTime.now().toIso8601String(),
      },
    };
  }

  void setToken(String token) {
    _token = token;
  }

  void clearToken() {
    _token = null;
  }

  String? get token => _token;
}