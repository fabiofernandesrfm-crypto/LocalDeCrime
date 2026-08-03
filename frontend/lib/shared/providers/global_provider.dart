import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/usuario_model.dart';
import '../repositories/auth_repository.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthState {
  final AuthStatus status;
  final UsuarioModel? user;
  final String? token;
  final String? errorMessage;

  const AuthState({
    this.status = AuthStatus.unknown,
    this.user,
    this.token,
    this.errorMessage,
  });

  AuthState copyWith({
    AuthStatus? status,
    UsuarioModel? user,
    String? token,
    String? errorMessage,
    bool clearError = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      token: token ?? this.token,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

class GlobalNotifier extends StateNotifier<AuthState> {
  final AuthRepository _authRepo = AuthRepository();

  GlobalNotifier() : super(const AuthState());

  Future<void> login(String matricula, String senha) async {
    try {
      state = state.copyWith(clearError: true);
      final response = await _authRepo.login(matricula, senha);

      final token = response['accessToken'] as String;
      final userJson = response['user'] as Map<String, dynamic>;

      _authRepo.setToken(token);

      state = state.copyWith(
        status: AuthStatus.authenticated,
        token: token,
        user: UsuarioModel.fromJson(userJson),
      );
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        errorMessage: e.toString(),
      );
    }
  }

  void logout() {
    _authRepo.clearToken();
    state = const AuthState(status: AuthStatus.unauthenticated);
  }

  void setAuthenticated() {
    state = state.copyWith(status: AuthStatus.authenticated);
  }

  void setUnauthenticated() {
    state = state.copyWith(status: AuthStatus.unauthenticated);
  }
}

final globalProvider = StateNotifierProvider<GlobalNotifier, AuthState>(
  (ref) => GlobalNotifier(),
);