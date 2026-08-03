import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Estado da sessão: segundos decorridos desde o login.
class SessaoState {
  final int elapsedSeconds;
  final bool active;

  const SessaoState({
    this.elapsedSeconds = 0,
    this.active = false,
  });

  String get formatted {
    final h = (elapsedSeconds ~/ 3600).toString().padLeft(2, '0');
    final m = ((elapsedSeconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final s = (elapsedSeconds % 60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }
}

/// Gerencia o contador de tempo de sessão.
///
/// Inicia automaticamente ao chamar [start] (após login)
/// e zera ao chamar [stop] (no logout).
class SessaoNotifier extends StateNotifier<SessaoState> {
  Timer? _timer;

  SessaoNotifier() : super(const SessaoState());

  void start() {
    _timer?.cancel();
    state = const SessaoState(elapsedSeconds: 0, active: true);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (state.active) {
        state = SessaoState(elapsedSeconds: state.elapsedSeconds + 1, active: true);
      }
    });
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
    state = const SessaoState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

final sessaoProvider = StateNotifierProvider<SessaoNotifier, SessaoState>(
  (ref) => SessaoNotifier(),
);