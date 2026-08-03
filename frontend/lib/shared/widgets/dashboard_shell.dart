import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../core/theme/app_theme.dart';
import '../providers/sessao_provider.dart';
import 'pcpe_side_menu.dart';
import 'pcpe_avatar.dart';

class DashboardShell extends ConsumerStatefulWidget {
  final Widget child;

  const DashboardShell({super.key, required this.child});

  @override
  ConsumerState<DashboardShell> createState() => _DashboardShellState();
}

class _DashboardShellState extends ConsumerState<DashboardShell> {
  String get currentRoute => GoRouterState.of(context).uri.toString();

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;
    final isTablet = ResponsiveBreakpoints.of(context).isTablet;
    final useRail = isTablet;
    final useDrawer = true;
    final useBottomNav = isMobile;

    return Scaffold(
      backgroundColor: PCPEColors.background,
      appBar: _buildAppBar(context, isMobile),
      drawer: useDrawer && !useRail
          ? PCPESideMenu(
              userName: 'Fabio Fernandes dos Santos',
              userRole: 'Agente de Polícia Civil',
              userUnit: 'DTI – UNISA',
              currentRoute: currentRoute,
              onNavigate: (route) => context.go(route),
            )
          : null,
      body: Row(
        children: [
          if (!isMobile) _buildNavigationRail(context),
          Expanded(child: widget.child),
        ],
      ),
      bottomNavigationBar: useBottomNav ? _buildBottomNav(context) : null,
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, bool isMobile) {
    return AppBar(
      backgroundColor: PCPEColors.pureWhite,
      elevation: 0,
      shadowColor: Colors.black12,
      title: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFF1B1B1B),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.shield, size: 20, color: PCPEColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'POLÍCIA CIVIL DE PERNAMBUCO',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: PCPEColors.darkGray,
                    letterSpacing: 0.8,
                  ),
                ),
                Text(
                  'Sistema de Registro de Atendimento em Local de Crime',
                  style: TextStyle(fontSize: 8, color: PCPEColors.mediumGray),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        // Session counter + indicator
        _buildSessionIndicator(),
        if (isMobile)
          IconButton(
            icon: const Badge(
              smallSize: 8,
              child: Icon(Icons.notifications_outlined, color: PCPEColors.darkGray),
            ),
            onPressed: () {},
          ),
        if (isMobile)
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu, color: PCPEColors.primary),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
        if (!isMobile)
          Padding(
            padding: const EdgeInsets.only(right: 4),
            child: Row(
              children: [
                IconButton(
                  icon: const Badge(
                    smallSize: 8,
                    child: Icon(Icons.notifications_outlined, color: PCPEColors.darkGray),
                  ),
                  onPressed: () {},
                ),
                const SizedBox(width: 4),
                PopupMenuButton<String>(
                  offset: const Offset(0, 48),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  onSelected: (value) {
                    if (value == 'perfil') context.go('/perfil');
                    if (value == 'configuracoes') context.go('/configuracoes');
                    if (value == 'sair') {
                      ref.read(sessaoProvider.notifier).stop();
                      context.go('/login');
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'perfil',
                      child: Row(
                        children: [
                          const Icon(Icons.person_outline, size: 18, color: PCPEColors.primary),
                          const SizedBox(width: 10),
                          const Text('Meu Perfil', style: TextStyle(fontSize: 13)),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'configuracoes',
                      child: Row(
                        children: [
                          const Icon(Icons.settings_outlined, size: 18, color: PCPEColors.primary),
                          const SizedBox(width: 10),
                          const Text('Configurações', style: TextStyle(fontSize: 13)),
                        ],
                      ),
                    ),
                    const PopupMenuDivider(height: 0.5),
                    PopupMenuItem(
                      value: 'sair',
                      child: Row(
                        children: [
                          const Icon(Icons.logout, size: 18, color: PCPEColors.error),
                          const SizedBox(width: 10),
                          const Text('Sair', style: TextStyle(fontSize: 13, color: PCPEColors.error)),
                        ],
                      ),
                    ),
                  ],
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: PCPEColors.cardGray,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: PCPEColors.lightGray.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const PCPEAvatar(name: 'Fabio Fernandes dos Santos', size: 28),
                        const SizedBox(width: 8),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Ag. Fabio Fernandes',
                              style: TextStyle(fontSize: 11, color: PCPEColors.black, fontWeight: FontWeight.w600),
                            ),
                              Text(
                                'Agente de Polícia Civil • DTI – UNISA',
                              style: TextStyle(fontSize: 9, color: PCPEColors.mediumGray),
                            ),
                          ],
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.keyboard_arrow_down, size: 16, color: PCPEColors.mediumGray),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildSessionIndicator() {
    final sessaoState = ref.watch(sessaoProvider);

    if (!sessaoState.active) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(right: 4),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: PCPEColors.cardGray,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: PCPEColors.lightGray.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: const BoxDecoration(
              color: PCPEColors.success,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Sessão',
                style: TextStyle(fontSize: 7, color: PCPEColors.mediumGray.withValues(alpha: 0.8), fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 1),
              Text(
                sessaoState.formatted,
                style: const TextStyle(
                  fontSize: 11,
                  color: PCPEColors.darkGray,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'monospace',
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(width: 6),
          Text(
            '● Sessão Ativa',
            style: TextStyle(fontSize: 7, color: PCPEColors.success.withValues(alpha: 0.8), fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationRail(BuildContext context) {
    return Container(
      width: 72,
      decoration: BoxDecoration(
        color: PCPEColors.pureWhite,
        border: Border(right: BorderSide(color: PCPEColors.lightGray.withValues(alpha: 0.2))),
      ),
      child: Column(
        children: [
          const SizedBox(height: 8),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ...PCPESideMenu.menuItems.map((item) => _buildRailItem(
                        icon: item.icon,
                        label: item.label,
                        isActive: currentRoute == item.route,
                        onTap: () => context.go(item.route),
                      )),
                  const SizedBox(height: 8),
                  Container(
                    height: 1,
                    color: PCPEColors.lightGray.withValues(alpha: 0.3),
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                  ...PCPESideMenu.bottomItems.map((item) => _buildRailItem(
                        icon: item.icon,
                        label: item.label,
                        isActive: currentRoute == item.route,
                        onTap: () => context.go(item.route),
                      )),
                ],
              ),
            ),
          ),
          Container(
            height: 1,
            color: PCPEColors.lightGray.withValues(alpha: 0.3),
            margin: const EdgeInsets.symmetric(horizontal: 12),
          ),
          _buildRailItem(
            icon: Icons.logout,
            label: 'Sair',
            onTap: () {
              ref.read(sessaoProvider.notifier).stop();
              context.go('/login');
            },
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildRailItem({
    required IconData icon,
    required String label,
    VoidCallback? onTap,
    bool isActive = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        splashColor: PCPEColors.primary.withValues(alpha: 0.05),
        child: Container(
          width: 64,
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isActive ? PCPEColors.primary.withValues(alpha: 0.08) : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 20,
                color: isActive ? PCPEColors.primary : PCPEColors.mediumGray,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  color: isActive ? PCPEColors.primary : PCPEColors.mediumGray,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: PCPEColors.pureWhite,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(5, (index) {
              final isAdd = index == 2;
              if (isAdd) {
                return GestureDetector(
                  onTap: () => context.go('/nova-ocorrencia'),
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: PCPEColors.primary,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: PCPEColors.primary.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.add, color: PCPEColors.pureWhite, size: 26),
                  ),
                );
              }

              final routes = ['/dashboard', '/ocorrencias', '', '/atendimentos', '/configuracoes'];
              final labels = ['Início', 'Registros', '', 'Consultas', 'Ajustes'];
              final icons = [Icons.dashboard_outlined, Icons.folder_outlined, null, Icons.medical_services_outlined, Icons.settings_outlined];
              final isActive = currentRoute.startsWith(routes[index]);

              return GestureDetector(
                onTap: () {
                  if (routes[index].isNotEmpty) context.go(routes[index]);
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      icons[index],
                      size: 22,
                      color: isActive ? PCPEColors.primary : PCPEColors.mediumGray,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      labels[index],
                      style: TextStyle(
                        fontSize: 10,
                        color: isActive ? PCPEColors.primary : PCPEColors.mediumGray,
                        fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}