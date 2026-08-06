import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/splash/splash_screen.dart';
import '../features/login/login_screen.dart';
import '../features/dashboard/dashboard_screen.dart';
import '../features/nova_ocorrencia/nova_ocorrencia_screen.dart';
import '../features/ocorrencias/ocorrencias_screen.dart';
import '../features/pessoas/pessoas_screen.dart';
import '../features/vestigios/vestigios_screen.dart';
import '../features/objetos/objetos_screen.dart';
import '../features/veiculos/veiculos_screen.dart';
import '../features/fotografias/fotografias_screen.dart';
import '../features/linha_do_tempo/linha_do_tempo_screen.dart';
import '../features/sincronizacao/sincronizacao_screen.dart';
import '../features/configuracoes/configuracoes_screen.dart';
import '../features/perfil/perfil_screen.dart';
import '../features/sobre/sobre_screen.dart';
import '../features/usuarios/usuarios_screen.dart';
import '../shared/widgets/dashboard_shell.dart';
import '../shared/widgets/not_found_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/splash',
  errorBuilder: (context, state) => const NotFoundScreen(),
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    ShellRoute(
      builder: (context, state, child) => DashboardShell(child: child),
      routes: [
        GoRoute(
          path: '/dashboard',
          builder: (context, state) => const DashboardScreen(),
        ),
        GoRoute(
          path: '/nova-ocorrencia',
          builder: (context, state) => const NovaOcorrenciaScreen(),
        ),
        GoRoute(
          path: '/ocorrencias',
          builder: (context, state) => const OcorrenciasScreen(),
        ),
        GoRoute(
          path: '/pessoas',
          builder: (context, state) => const PessoasScreen(),
        ),
        GoRoute(
          path: '/vestigios',
          builder: (context, state) => const VestigiosScreen(),
        ),
        GoRoute(
          path: '/objetos',
          builder: (context, state) => const ObjetosScreen(),
        ),
        GoRoute(
          path: '/veiculos',
          builder: (context, state) => const VeiculosScreen(),
        ),
        GoRoute(
          path: '/fotografias',
          builder: (context, state) => const FotografiasScreen(),
        ),
        GoRoute(
          path: '/linha-do-tempo',
          builder: (context, state) => const LinhaDoTempoScreen(),
        ),
        GoRoute(
          path: '/sincronizacao',
          builder: (context, state) => const SincronizacaoScreen(),
        ),
        GoRoute(
          path: '/configuracoes',
          builder: (context, state) => const ConfiguracoesScreen(),
        ),
        GoRoute(
          path: '/perfil',
          builder: (context, state) => const PerfilScreen(),
        ),
        GoRoute(
          path: '/sobre',
          builder: (context, state) => const SobreScreen(),
        ),
        GoRoute(
          path: '/usuarios',
          builder: (context, state) => const UsuariosScreen(),
        ),
      ],
    ),
  ],
);
